package ch.zhaw.iwi.devops.demo;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(ModuleController.class)
public class ModuleControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    private Module testModule;

    @BeforeEach
    public void setup() {
        testModule = new Module("Test Modul", "TM100", 3, "Beschreibung", true);
    }

    @Test
    public void testPing() throws Exception {
        mockMvc.perform(get("/services/module/ping"))
                .andExpect(status().isOk());
    }

    @Test
    public void testCreateModule() throws Exception {
        mockMvc.perform(post("/services/module")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testModule)))
                .andExpect(status().isOk());
    }

    @Test
    public void testTestEndpoint() throws Exception {
        mockMvc.perform(get("/test/module"))
                .andExpect(status().isOk());
    }
}
