package ch.zhaw.iwi.devops.demo;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ModuleTest {

    @Test
    public void testConstructorAndGetters() {
        Module module = new Module("Software Engineering", "SE101", 6, "Einfuhrung in die Softwareentwicklung", true);

        assertEquals("Software Engineering", module.getModuleName());
        assertEquals("SE101", module.getModuleCode());
        assertEquals(6, module.getCredits());
        assertEquals("Einfuhrung in die Softwareentwicklung", module.getDescription());
        assertTrue(module.isActive());
    }

    @Test
    public void testSetters() {
        Module module = new Module();
        module.setModuleName("Projektmanagement");
        module.setModuleCode("PM202");
        module.setCredits(3);
        module.setDescription("Grundlagen des Projektmanagements");
        module.setActive(false);

        assertEquals("Projektmanagement", module.getModuleName());
        assertEquals("PM202", module.getModuleCode());
        assertEquals(3, module.getCredits());
        assertEquals("Grundlagen des Projektmanagements", module.getDescription());
        assertFalse(module.isActive());
    }
} 
