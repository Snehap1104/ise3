package com.app;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Main {
    public static void main(String[] args) {
        // Get the current time for demonstration
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        System.out.println("--- Java Docker Pipeline Demo ---");
        System.out.println("Hello from the Java application running inside a Docker container!");
        System.out.println("Container Start Time: " + timestamp);
        System.out.println("-------------------------------");
    }
}
