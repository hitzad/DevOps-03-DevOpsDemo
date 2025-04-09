package ch.zhaw.iwi.devops.demo;

public class Module {

    private String moduleName;
    private String moduleCode;
    private int credits;
    private String description;
    private boolean active;

    public Module() {
    }

    public Module(String moduleName, String moduleCode, int credits, String description, boolean active) {
        this.moduleName = moduleName;
        this.moduleCode = moduleCode;
        this.credits = credits;
        this.description = description;
        this.active = active;
    }

    public String getModuleName() {
        return moduleName;
    }

    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }

    public String getModuleCode() {
        return moduleCode;
    }

    public void setModuleCode(String moduleCode) {
        this.moduleCode = moduleCode;
    }

    public int getCredits() {
        return credits;
    }

    public void setCredits(int credits) {
        this.credits = credits;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
