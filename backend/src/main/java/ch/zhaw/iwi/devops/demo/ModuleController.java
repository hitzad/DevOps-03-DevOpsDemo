package ch.zhaw.iwi.devops.demo;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin
@RestController
public class ModuleController {

    private Map<Integer, Module> modules = new HashMap<>();

    @EventListener(ApplicationReadyEvent.class)
    public void init() {
        modules.put(1, new Module("Software Engineering", "SE101", 5, "Basics of software development", true));
        modules.put(2, new Module("Databases", "DB102", 4, "Introduction to relational databases", true));
        modules.put(3, new Module("DevOps", "DO201", 3, "Automation and CI/CD pipelines", false));
        System.out.println("Module data initialized.");
    }

    @GetMapping("/test/module")
    public String test() {
        return "Module service is running!";
    }

    @GetMapping("/services/module/ping")
    public String ping() {
        return "{ \"status\": \"ok\", \"userId\": \"admin\", \"languageCode\": \"de\", \"version\": \"0.0.1\" }";
    }

    @GetMapping("/services/module/count")
    public int count() {
        return this.modules.size();
    }

    @GetMapping("/services/module")
    public List<PathListEntry<Integer>> listModules() {
        var result = new ArrayList<PathListEntry<Integer>>();
        int id = 1;
        for (var module : this.modules.values()) {
            var entry = new PathListEntry<Integer>();
            entry.setEntryKey(id, "moduleKey");
            entry.setName(module.getModuleName());
            entry.getDetails().add("Code: " + module.getModuleCode());
            entry.getDetails().add("Credits: " + module.getCredits());
            entry.getDetails().add("Description: " + module.getDescription());
            entry.getDetails().add("Active: " + module.isActive());
            entry.setTooltip(module.getDescription());
            result.add(entry);
            id++;
        }
        return result;
    }

    @GetMapping("/services/module/{id}")
    public Module getModule(@PathVariable Integer id) {
        return this.modules.get(id);
    }

    @PostMapping("/services/module")
    public void createModule(@RequestBody Module module) {
        int newId = this.modules.keySet().stream().max(Comparator.naturalOrder()).orElse(0) + 1;
        this.modules.put(newId, module);
    }

    @PutMapping("/services/module/{id}")
    public void updateModule(@PathVariable Integer id, @RequestBody Module module) {
        this.modules.put(id, module);
    }

    @DeleteMapping("/services/module/{id}")
    public Module deleteModule(@PathVariable Integer id) {
        return this.modules.remove(id);
    }
}
