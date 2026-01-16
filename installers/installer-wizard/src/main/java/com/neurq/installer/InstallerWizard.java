package com.neurq.installer;

import com.neurq.licensing.LicenseManager;
import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.stage.Stage;
import javafx.stage.DirectoryChooser;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Installer Wizard for QS-DPDP OS
 * Supports Trial and Licensed installations
 */
public class InstallerWizard extends Application {
    private Stage primaryStage;
    private int currentStep = 0;
    private InstallerConfig config = new InstallerConfig();
    
    @Override
    public void start(Stage primaryStage) {
        this.primaryStage = primaryStage;
        primaryStage.setTitle("QS-DPDP OS Installation Wizard");
        primaryStage.setWidth(800);
        primaryStage.setHeight(600);
        primaryStage.setResizable(false);
        
        showWelcomeStep();
    }
    
    private void showWelcomeStep() {
        VBox vbox = new VBox(20);
        vbox.setPadding(new Insets(40));
        vbox.setAlignment(javafx.geometry.Pos.CENTER);
        
        Label title = new Label("Welcome to QS-DPDP OS Installation");
        title.setStyle("-fx-font-size: 24px; -fx-font-weight: bold;");
        
        Label description = new Label(
            "Quantum-Safe DPDP Compliance Operating System\n" +
            "This wizard will guide you through the installation process."
        );
        description.setStyle("-fx-font-size: 14px;");
        
        Button nextBtn = new Button("Next >");
        nextBtn.setOnAction(e -> showLicenseTypeStep());
        
        vbox.getChildren().addAll(title, description, nextBtn);
        
        Scene scene = new Scene(vbox);
        primaryStage.setScene(scene);
        primaryStage.show();
    }
    
    private void showLicenseTypeStep() {
        VBox vbox = new VBox(20);
        vbox.setPadding(new Insets(40));
        
        Label title = new Label("Select License Type");
        title.setStyle("-fx-font-size: 18px; -fx-font-weight: bold;");
        
        ToggleGroup licenseGroup = new ToggleGroup();
        
        RadioButton trialBtn = new RadioButton("Trial License (14 days)");
        trialBtn.setToggleGroup(licenseGroup);
        trialBtn.setSelected(true);
        trialBtn.setOnAction(e -> config.setLicenseType(LicenseManager.LicenseType.TRIAL));
        
        RadioButton commercialBtn = new RadioButton("Commercial License");
        commercialBtn.setToggleGroup(licenseGroup);
        commercialBtn.setOnAction(e -> config.setLicenseType(LicenseManager.LicenseType.COMMERCIAL));
        
        RadioButton enterpriseBtn = new RadioButton("Enterprise Suite License");
        enterpriseBtn.setToggleGroup(licenseGroup);
        enterpriseBtn.setOnAction(e -> config.setLicenseType(LicenseManager.LicenseType.ENTERPRISE_SUITE));
        
        RadioButton govtBtn = new RadioButton("Government/PSU License");
        govtBtn.setToggleGroup(licenseGroup);
        govtBtn.setOnAction(e -> config.setLicenseType(LicenseManager.LicenseType.GOVERNMENT_PSU));
        
        RadioButton airGappedBtn = new RadioButton("Air-Gapped License");
        airGappedBtn.setToggleGroup(licenseGroup);
        airGappedBtn.setOnAction(e -> config.setLicenseType(LicenseManager.LicenseType.AIR_GAPPED));
        
        TextField licenseKeyField = new TextField();
        licenseKeyField.setPromptText("Enter license key (if licensed)");
        licenseKeyField.setDisable(trialBtn.isSelected());
        
        trialBtn.setOnAction(e -> {
            config.setLicenseType(LicenseManager.LicenseType.TRIAL);
            licenseKeyField.setDisable(true);
        });
        commercialBtn.setOnAction(e -> {
            config.setLicenseType(LicenseManager.LicenseType.COMMERCIAL);
            licenseKeyField.setDisable(false);
        });
        enterpriseBtn.setOnAction(e -> {
            config.setLicenseType(LicenseManager.LicenseType.ENTERPRISE_SUITE);
            licenseKeyField.setDisable(false);
        });
        govtBtn.setOnAction(e -> {
            config.setLicenseType(LicenseManager.LicenseType.GOVERNMENT_PSU);
            licenseKeyField.setDisable(false);
        });
        airGappedBtn.setOnAction(e -> {
            config.setLicenseType(LicenseManager.LicenseType.AIR_GAPPED);
            licenseKeyField.setDisable(false);
        });
        
        HBox buttonBox = new HBox(10);
        Button backBtn = new Button("< Back");
        backBtn.setOnAction(e -> showWelcomeStep());
        Button nextBtn = new Button("Next >");
        nextBtn.setOnAction(e -> {
            if (!trialBtn.isSelected() && licenseKeyField.getText().isEmpty()) {
                showAlert("License key required for licensed installations");
                return;
            }
            config.setLicenseKey(licenseKeyField.getText());
            showInstallationPathStep();
        });
        buttonBox.getChildren().addAll(backBtn, nextBtn);
        
        vbox.getChildren().addAll(title, trialBtn, commercialBtn, enterpriseBtn, govtBtn, airGappedBtn,
            new Label("License Key:"), licenseKeyField, buttonBox);
        
        Scene scene = new Scene(vbox);
        primaryStage.setScene(scene);
    }
    
    private void showInstallationPathStep() {
        VBox vbox = new VBox(20);
        vbox.setPadding(new Insets(40));
        
        Label title = new Label("Select Installation Path");
        title.setStyle("-fx-font-size: 18px; -fx-font-weight: bold;");
        
        TextField pathField = new TextField(System.getProperty("user.home") + File.separator + "QS-DPDP-OS");
        pathField.setPrefWidth(400);
        
        Button browseBtn = new Button("Browse...");
        browseBtn.setOnAction(e -> {
            DirectoryChooser chooser = new DirectoryChooser();
            chooser.setTitle("Select Installation Directory");
            File selected = chooser.showDialog(primaryStage);
            if (selected != null) {
                pathField.setText(selected.getAbsolutePath());
            }
        });
        
        HBox pathBox = new HBox(10);
        pathBox.getChildren().addAll(pathField, browseBtn);
        
        HBox buttonBox = new HBox(10);
        Button backBtn = new Button("< Back");
        backBtn.setOnAction(e -> showLicenseTypeStep());
        Button nextBtn = new Button("Next >");
        nextBtn.setOnAction(e -> {
            config.setInstallPath(pathField.getText());
            showDatabaseStep();
        });
        buttonBox.getChildren().addAll(backBtn, nextBtn);
        
        vbox.getChildren().addAll(title, new Label("Installation Path:"), pathBox, buttonBox);
        
        Scene scene = new Scene(vbox);
        primaryStage.setScene(scene);
    }
    
    private void showDatabaseStep() {
        VBox vbox = new VBox(20);
        vbox.setPadding(new Insets(40));
        
        Label title = new Label("Database Configuration");
        title.setStyle("-fx-font-size: 18px; -fx-font-weight: bold;");
        
        ComboBox<String> dbTypeCombo = new ComboBox<>();
        dbTypeCombo.getItems().addAll("SQLite (Default)", "Oracle", "PostgreSQL", "SQL Server", "MySQL");
        dbTypeCombo.setValue("SQLite (Default)");
        dbTypeCombo.setOnAction(e -> {
            String selected = dbTypeCombo.getValue();
            config.setDatabaseType(selected.split(" ")[0]);
        });
        
        TextField hostField = new TextField("localhost");
        TextField portField = new TextField("5432");
        TextField dbNameField = new TextField("qsdpdp");
        TextField userField = new TextField();
        PasswordField passwordField = new PasswordField();
        
        GridPane dbGrid = new GridPane();
        dbGrid.setHgap(10);
        dbGrid.setVgap(10);
        dbGrid.add(new Label("Database Type:"), 0, 0);
        dbGrid.add(dbTypeCombo, 1, 0);
        dbGrid.add(new Label("Host:"), 0, 1);
        dbGrid.add(hostField, 1, 1);
        dbGrid.add(new Label("Port:"), 0, 2);
        dbGrid.add(portField, 1, 2);
        dbGrid.add(new Label("Database Name:"), 0, 3);
        dbGrid.add(dbNameField, 1, 3);
        dbGrid.add(new Label("Username:"), 0, 4);
        dbGrid.add(userField, 1, 4);
        dbGrid.add(new Label("Password:"), 0, 5);
        dbGrid.add(passwordField, 1, 5);
        
        CheckBox createDbCheckbox = new CheckBox("Auto-create database if not exists");
        createDbCheckbox.setSelected(true);
        
        HBox buttonBox = new HBox(10);
        Button backBtn = new Button("< Back");
        backBtn.setOnAction(e -> showInstallationPathStep());
        Button nextBtn = new Button("Next >");
        nextBtn.setOnAction(e -> {
            config.setDatabaseHost(hostField.getText());
            config.setDatabasePort(portField.getText());
            config.setDatabaseName(dbNameField.getText());
            config.setDatabaseUser(userField.getText());
            config.setDatabasePassword(passwordField.getText());
            config.setAutoCreateDatabase(createDbCheckbox.isSelected());
            showSectorPoliciesStep();
        });
        buttonBox.getChildren().addAll(backBtn, nextBtn);
        
        vbox.getChildren().addAll(title, dbGrid, createDbCheckbox, buttonBox);
        
        Scene scene = new Scene(vbox);
        primaryStage.setScene(scene);
    }
    
    private void showSectorPoliciesStep() {
        VBox vbox = new VBox(20);
        vbox.setPadding(new Insets(40));
        
        Label title = new Label("Select Sector Policies");
        title.setStyle("-fx-font-size: 18px; -fx-font-weight: bold;");
        
        Label description = new Label("Select the sectors for which you want to load DPDP policies:");
        
        List<CheckBox> sectorCheckboxes = new ArrayList<>();
        String[] sectors = {
            "Banking & Financial Services",
            "Healthcare",
            "E-Commerce",
            "Education",
            "Government",
            "Telecommunications",
            "Insurance",
            "Manufacturing",
            "Retail",
            "IT/ITES",
            "Real Estate",
            "Transportation"
        };
        
        for (String sector : sectors) {
            CheckBox checkbox = new CheckBox(sector);
            checkbox.setSelected(true); // Default all selected
            sectorCheckboxes.add(checkbox);
        }
        
        VBox sectorsBox = new VBox(5);
        sectorsBox.getChildren().addAll(sectorCheckboxes);
        ScrollPane scrollPane = new ScrollPane(sectorsBox);
        scrollPane.setPrefHeight(200);
        
        HBox buttonBox = new HBox(10);
        Button backBtn = new Button("< Back");
        backBtn.setOnAction(e -> showDatabaseStep());
        Button nextBtn = new Button("Next >");
        nextBtn.setOnAction(e -> {
            List<String> selectedSectors = new ArrayList<>();
            for (CheckBox cb : sectorCheckboxes) {
                if (cb.isSelected()) {
                    selectedSectors.add(cb.getText());
                }
            }
            config.setSelectedSectors(selectedSectors);
            showDemoDataStep();
        });
        buttonBox.getChildren().addAll(backBtn, nextBtn);
        
        vbox.getChildren().addAll(title, description, scrollPane, buttonBox);
        
        Scene scene = new Scene(vbox);
        primaryStage.setScene(scene);
    }
    
    private void showDemoDataStep() {
        VBox vbox = new VBox(20);
        vbox.setPadding(new Insets(40));
        
        Label title = new Label("Demo Data");
        title.setStyle("-fx-font-size: 18px; -fx-font-weight: bold;");
        
        Label description = new Label(
            "Would you like to load demo data?\n" +
            "This includes 1500+ sample records for testing and demonstration."
        );
        
        ToggleGroup demoGroup = new ToggleGroup();
        RadioButton yesBtn = new RadioButton("Yes, load demo data");
        yesBtn.setToggleGroup(demoGroup);
        yesBtn.setSelected(true);
        
        RadioButton noBtn = new RadioButton("No, start with empty database");
        noBtn.setToggleGroup(demoGroup);
        
        ComboBox<String> demoScenarioCombo = new ComboBox<>();
        demoScenarioCombo.getItems().addAll(
            "Cooperative Bank (Primary)",
            "Healthcare Organization",
            "E-Commerce Platform",
            "Educational Institution",
            "Government Department"
        );
        demoScenarioCombo.setValue("Cooperative Bank (Primary)");
        demoScenarioCombo.setDisable(noBtn.isSelected());
        
        noBtn.setOnAction(e -> demoScenarioCombo.setDisable(true));
        yesBtn.setOnAction(e -> {
            demoScenarioCombo.setDisable(false);
            config.setLoadDemoData(true);
        });
        
        HBox buttonBox = new HBox(10);
        Button backBtn = new Button("< Back");
        backBtn.setOnAction(e -> showSectorPoliciesStep());
        Button nextBtn = new Button("Next >");
        nextBtn.setOnAction(e -> {
            config.setLoadDemoData(yesBtn.isSelected());
            config.setDemoScenario(demoScenarioCombo.getValue());
            showInstallationStep();
        });
        buttonBox.getChildren().addAll(backBtn, nextBtn);
        
        vbox.getChildren().addAll(title, description, yesBtn, noBtn, 
            new Label("Demo Scenario:"), demoScenarioCombo, buttonBox);
        
        Scene scene = new Scene(vbox);
        primaryStage.setScene(scene);
    }
    
    private void showInstallationStep() {
        VBox vbox = new VBox(20);
        vbox.setPadding(new Insets(40));
        
        Label title = new Label("Installation Summary");
        title.setStyle("-fx-font-size: 18px; -fx-font-weight: bold;");
        
        TextArea summaryArea = new TextArea();
        summaryArea.setEditable(false);
        summaryArea.setText(config.toString());
        summaryArea.setPrefRowCount(15);
        
        ProgressBar progressBar = new ProgressBar(0);
        progressBar.setPrefWidth(400);
        
        Label statusLabel = new Label("Ready to install...");
        
        Button installBtn = new Button("Install");
        installBtn.setOnAction(e -> {
            installBtn.setDisable(true);
            performInstallation(progressBar, statusLabel);
        });
        
        Button cancelBtn = new Button("Cancel");
        cancelBtn.setOnAction(e -> primaryStage.close());
        
        HBox buttonBox = new HBox(10);
        buttonBox.getChildren().addAll(installBtn, cancelBtn);
        
        vbox.getChildren().addAll(title, summaryArea, progressBar, statusLabel, buttonBox);
        
        Scene scene = new Scene(vbox);
        primaryStage.setScene(scene);
    }
    
    private void performInstallation(ProgressBar progressBar, Label statusLabel) {
        new Thread(() -> {
            try {
                // Step 1: Create installation directory
                updateProgress(progressBar, statusLabel, 0.1, "Creating installation directory...");
                Files.createDirectories(Paths.get(config.getInstallPath()));
                
                // Step 2: Copy application files
                updateProgress(progressBar, statusLabel, 0.3, "Copying application files...");
                // Copy JARs, native libraries, etc.
                
                // Step 3: Create database
                updateProgress(progressBar, statusLabel, 0.5, "Creating database...");
                createDatabase();
                
                // Step 4: Load sector policies
                updateProgress(progressBar, statusLabel, 0.7, "Loading sector policies...");
                loadSectorPolicies();
                
                // Step 5: Load demo data (if selected)
                if (config.isLoadDemoData()) {
                    updateProgress(progressBar, statusLabel, 0.85, "Loading demo data...");
                    loadDemoData();
                }
                
                // Step 6: Create license file
                updateProgress(progressBar, statusLabel, 0.95, "Creating license file...");
                createLicenseFile();
                
                // Complete
                updateProgress(progressBar, statusLabel, 1.0, "Installation completed successfully!");
                
                javafx.application.Platform.runLater(() -> {
                    Alert alert = new Alert(Alert.AlertType.INFORMATION);
                    alert.setTitle("Installation Complete");
                    alert.setHeaderText("QS-DPDP OS has been installed successfully!");
                    alert.setContentText("Click OK to launch the application.");
                    alert.showAndWait();
                    primaryStage.close();
                });
                
            } catch (Exception e) {
                javafx.application.Platform.runLater(() -> {
                    Alert alert = new Alert(Alert.AlertType.ERROR);
                    alert.setTitle("Installation Error");
                    alert.setHeaderText("Installation failed");
                    alert.setContentText(e.getMessage());
                    alert.showAndWait();
                });
            }
        }).start();
    }
    
    private void updateProgress(ProgressBar progressBar, Label statusLabel, 
                               double progress, String status) {
        javafx.application.Platform.runLater(() -> {
            progressBar.setProgress(progress);
            statusLabel.setText(status);
        });
    }
    
    private void createDatabase() throws Exception {
        if ("SQLite".equals(config.getDatabaseType())) {
            // Create SQLite database
            String dbPath = config.getInstallPath() + File.separator + "qsdpdp.db";
            Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
            Statement stmt = conn.createStatement();
            
            // Create tables
            String schema = new String(Files.readAllBytes(
                Paths.get("demo-data/sqlite/schema.sql")));
            stmt.execute(schema);
            
            conn.close();
        } else {
            // Create database for other types
            // Implementation for Oracle, PostgreSQL, etc.
        }
    }
    
    private void loadSectorPolicies() {
        // Load sector-specific DPDP policies
    }
    
    private void loadDemoData() {
        // Load 1500+ demo records
    }
    
    private void createLicenseFile() {
        // Create license file based on license type
    }
    
    private void showAlert(String message) {
        Alert alert = new Alert(Alert.AlertType.WARNING);
        alert.setTitle("Warning");
        alert.setContentText(message);
        alert.showAndWait();
    }
    
    public static void main(String[] args) {
        launch(args);
    }
    
    private static class InstallerConfig {
        private LicenseManager.LicenseType licenseType;
        private String licenseKey;
        private String installPath;
        private String databaseType = "SQLite";
        private String databaseHost;
        private String databasePort;
        private String databaseName;
        private String databaseUser;
        private String databasePassword;
        private boolean autoCreateDatabase = true;
        private List<String> selectedSectors = new ArrayList<>();
        private boolean loadDemoData = false;
        private String demoScenario;
        
        // Getters and setters
        public void setLicenseType(LicenseManager.LicenseType type) { this.licenseType = type; }
        public void setLicenseKey(String key) { this.licenseKey = key; }
        public void setInstallPath(String path) { this.installPath = path; }
        public void setDatabaseType(String type) { this.databaseType = type; }
        public void setDatabaseHost(String host) { this.databaseHost = host; }
        public void setDatabasePort(String port) { this.databasePort = port; }
        public void setDatabaseName(String name) { this.databaseName = name; }
        public void setDatabaseUser(String user) { this.databaseUser = user; }
        public void setDatabasePassword(String password) { this.databasePassword = password; }
        public void setAutoCreateDatabase(boolean auto) { this.autoCreateDatabase = auto; }
        public void setSelectedSectors(List<String> sectors) { this.selectedSectors = sectors; }
        public void setLoadDemoData(boolean load) { this.loadDemoData = load; }
        public void setDemoScenario(String scenario) { this.demoScenario = scenario; }
        
        public LicenseManager.LicenseType getLicenseType() { return licenseType; }
        public String getLicenseKey() { return licenseKey; }
        public String getInstallPath() { return installPath; }
        public String getDatabaseType() { return databaseType; }
        public String getDatabaseHost() { return databaseHost; }
        public String getDatabasePort() { return databasePort; }
        public String getDatabaseName() { return databaseName; }
        public String getDatabaseUser() { return databaseUser; }
        public String getDatabasePassword() { return databasePassword; }
        public boolean isAutoCreateDatabase() { return autoCreateDatabase; }
        public List<String> getSelectedSectors() { return selectedSectors; }
        public boolean isLoadDemoData() { return loadDemoData; }
        public String getDemoScenario() { return demoScenario; }
        
        @Override
        public String toString() {
            return String.format(
                "License Type: %s\n" +
                "Installation Path: %s\n" +
                "Database Type: %s\n" +
                "Database: %s@%s:%s/%s\n" +
                "Selected Sectors: %s\n" +
                "Load Demo Data: %s\n" +
                "Demo Scenario: %s",
                licenseType, installPath, databaseType,
                databaseUser, databaseHost, databasePort, databaseName,
                selectedSectors, loadDemoData, demoScenario
            );
        }
    }
}
