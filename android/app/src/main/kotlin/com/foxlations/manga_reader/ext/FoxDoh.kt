package com.foxlations.manga_reader.ext

import okhttp3.Dns
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONObject
import java.net.InetAddress

/**
 * An [okhttp3.Dns] that resolves hostnames over DNS-over-HTTPS (RFC 8484
 * "DNS-JSON") when enabled, and falls back to the system resolver otherwise or
 * on any failure — so turning DoH on can never hard-break source networking.
 *
 * A single mutable object: the enabled flag + endpoint are read live per lookup,
 * so a config change is picked up in place by the base client AND every source's
 * derived `newBuilder()` client (which copy the dns reference), with no rebuild.
 * The DoH query itself goes over a plain system-DNS client so it never recurses.
 *
 * Our own implementation (not OkHttp's okhttp-dnsoverhttps artifact).
 */
object FoxDoh : Dns {
    @Volatile
    var enabled: Boolean = false
        private set

    @Volatile
    private var url: String = ""

    private val bootstrap: OkHttpClient by lazy { OkHttpClient() }

    fun configure(enabled: Boolean, url: String) {
        this.url = url.trim()
        this.enabled = enabled && this.url.isNotEmpty()
    }

    override fun lookup(hostname: String): List<InetAddress> {
        if (!enabled) return Dns.SYSTEM.lookup(hostname)
        return try {
            val ips = query(hostname)
            if (ips.isNotEmpty()) ips else Dns.SYSTEM.lookup(hostname)
        } catch (_: Throwable) {
            Dns.SYSTEM.lookup(hostname)
        }
    }

    private fun query(host: String): List<InetAddress> {
        val out = ArrayList<InetAddress>()
        val base = url
        for (type in arrayOf("A", "AAAA")) {
            val sep = if (base.contains('?')) '&' else '?'
            val req = Request.Builder()
                .url("$base${sep}name=$host&type=$type")
                .header("Accept", "application/dns-json")
                .build()
            bootstrap.newCall(req).execute().use { resp ->
                if (!resp.isSuccessful) return@use
                val body = resp.body?.string() ?: return@use
                val answers = JSONObject(body).optJSONArray("Answer") ?: return@use
                for (i in 0 until answers.length()) {
                    val data = answers.getJSONObject(i).optString("data")
                    if (data.isNotEmpty()) {
                        // Literal IPs parse directly — no DNS, no recursion.
                        try {
                            out.add(InetAddress.getByName(data))
                        } catch (_: Throwable) {
                        }
                    }
                }
            }
        }
        return out
    }
}
