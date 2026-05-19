package com.homelab.demo;

import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class Application {
  @Value("\${APP_SECRET:not-set}")
  private String appSecret;

  @Value("\${APP_CONFIG_VALUE:default-config}")
  private String appConfigValue;

  public static void main(String[] args) {
    SpringApplication.run(Application.class, args);
  }

  @GetMapping("/health")
  public Map<String, String> health() {
    Map<String, String> out = new HashMap<>();
    out.put("status", "ok");
    return out;
  }

  @GetMapping("/env")
  public Map<String, String> env() {
    Map<String, String> out = new HashMap<>();
    String masked = appSecret.length() <= 4 ? "****" : appSecret.substring(0, 2) + "****" + appSecret.substring(appSecret.length() - 2);
    out.put("appSecretMasked", masked);
    return out;
  }

  @GetMapping("/config")
  public Map<String, String> config() {
    Map<String, String> out = new HashMap<>();
    out.put("appConfigValue", appConfigValue);
    return out;
  }
}
