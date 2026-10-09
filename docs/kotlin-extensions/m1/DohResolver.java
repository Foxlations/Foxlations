package foxtensions.net;

import java.net.InetAddress;
import java.net.URI;
import java.net.UnknownHostException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.spi.InetAddressResolver;
import java.net.spi.InetAddressResolver.LookupPolicy;
import java.net.spi.InetAddressResolverProvider;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

/**
 * The iOS Zero JVM's native DNS resolver is broken — getaddrinfo returns the wildcard
 * address (0.0.0.0 with -Djava.net.preferIPv4Stack=true, :: otherwise) instead of real
 * IPs — even though raw TCP works (verified: connect to 1.1.1.1:443 succeeds). This SPI
 * provider (JEP 418, JDK 18+) replaces the platform resolver JVM-wide with DNS-over-HTTPS
 * to Cloudflare at the LITERAL IP 1.1.1.1 — reachable without any DNS, since InetAddress
 * parses literal IPs directly and never calls back into this resolver. Fixes InetAddress
 * and therefore OkHttp's Dns.SYSTEM (which delegates to InetAddress.getAllByName) at once.
 *
 * Registered via META-INF/services/java.net.spi.InetAddressResolverProvider on the app
 * classpath; the JDK loads it through ServiceLoader at InetAddress initialization.
 */
public final class DohResolver extends InetAddressResolverProvider {

    private volatile HttpClient http;
    private final Pattern ipRe =
        Pattern.compile("\"data\"\\s*:\\s*\"(\\d{1,3}(?:\\.\\d{1,3}){3})\"");

    // The DoH endpoint, configurable from Dart (Advanced > DNS provider). It MUST
    // be a LITERAL-IP https URL: iOS native DNS is broken and this resolver IS the
    // DNS, so a hostname endpoint can't be resolved (it would recurse). Defaults to
    // Cloudflare's 1.1.1.1; setEndpoint ignores anything that isn't IPv4-host, so a
    // bad value can never break all name resolution.
    private static volatile String endpoint = "https://1.1.1.1/dns-query";
    private static final Pattern IPV4_URL =
        Pattern.compile("^https://\\d{1,3}(?:\\.\\d{1,3}){3}(?::\\d+)?/\\S*$");

    /** Called reflectively from SourceRunner.setDoh. No-op for a non-IP URL. */
    public static void setEndpoint(String url) {
        if (url != null && IPV4_URL.matcher(url.trim()).matches()) {
            endpoint = url.trim();
        }
    }

    @Override
    public String name() { return "foxtensions-doh"; }

    @Override
    public InetAddressResolver get(Configuration config) {
        final InetAddressResolver builtin = config.builtinResolver();
        return new InetAddressResolver() {
            @Override
            public Stream<InetAddress> lookupByName(String host, LookupPolicy policy)
                    throws UnknownHostException {
                return doh(host);
            }
            @Override
            public String lookupByAddress(byte[] addr) throws UnknownHostException {
                return builtin.lookupByAddress(addr);   // reverse DNS: rarely used, leave to platform
            }
        };
    }

    // Lazily build the HttpClient on first lookup (NOT during the early InetAddress init
    // that runs get()), so we don't touch the networking stack before it's ready.
    private HttpClient http() {
        HttpClient h = http;
        if (h == null) {
            synchronized (this) {
                h = http;
                if (h == null) {
                    h = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(8)).build();
                    http = h;
                }
            }
        }
        return h;
    }

    private Stream<InetAddress> doh(String host) throws UnknownHostException {
        // Try the user's configured provider first; if it returns no record or
        // errors (not every provider serves the JSON API the same way), fall back
        // to Cloudflare's 1.1.1.1 so resolution never breaks on iOS.
        List<InetAddress> out = queryOne(endpoint, host);
        if (out.isEmpty() && !endpoint.startsWith("https://1.1.1.1/")) {
            out = queryOne("https://1.1.1.1/dns-query", host);
        }
        if (!out.isEmpty()) return out.stream();
        throw new UnknownHostException("DoH: no A record for " + host);
    }

    private List<InetAddress> queryOne(String base, String host) {
        List<InetAddress> out = new ArrayList<>();
        try {
            String sep = base.indexOf('?') >= 0 ? "&" : "?";
            HttpRequest req = HttpRequest
                .newBuilder(URI.create(base + sep + "type=A&name=" + host))
                .header("accept", "application/dns-json")
                .timeout(Duration.ofSeconds(8))
                .GET().build();
            String body = http().send(req, HttpResponse.BodyHandlers.ofString()).body();
            Matcher m = ipRe.matcher(body);
            while (m.find()) {
                out.add(InetAddress.getByAddress(host, ipv4(m.group(1))));
            }
        } catch (Exception ignored) {
            // fall through — caller tries the next endpoint / throws
        }
        return out;
    }

    private static byte[] ipv4(String ip) {
        String[] p = ip.split("\\.");
        return new byte[] {
            (byte) Integer.parseInt(p[0]), (byte) Integer.parseInt(p[1]),
            (byte) Integer.parseInt(p[2]), (byte) Integer.parseInt(p[3]),
        };
    }
}
