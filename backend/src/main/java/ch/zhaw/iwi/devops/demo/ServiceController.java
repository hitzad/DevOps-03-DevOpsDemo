package ch.zhaw.iwi.devops.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ServiceController {

    @GetMapping("/services")
    public String hello() {
        return "Service is running";
    }
}
