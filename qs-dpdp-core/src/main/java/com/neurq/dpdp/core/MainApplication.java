package com.neurq.dpdp.core;

import com.neurq.licensing.LicenseManager;
import com.neurq.common.i18n.I18nManager;
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.stage.Stage;
import java.time.LocalDateTime;

/**
 * Main Application Entry Point
 * QS-DPDP Core Desktop Application
 */
public class MainApplication extends Application {
    private LicenseManager licenseManager;
    private ConsentManager consentManager;
    private DataPrincipalRightsManager rightsManager;
    private BreachNotificationManager breachManager;
    private ComplianceScoringEngine scoringEngine;
    
    @Override
    public void start(Stage primaryStage) {
        // Initialize license manager
        licenseManager = new LicenseManager();
        LicenseManager.LicenseValidationResult licenseResult = licenseManager.validateLicense();
        
        if (!licenseResult.isValid()) {
            showLicenseError(primaryStage, licenseResult.getMessage());
            return;
        }
        
        // Initialize database connection
        java.sql.Connection dbConnection = initializeDatabase();
        
        // Initialize repositories
        ConsentManager.ConsentRepository consentRepo = new com.neurq.dpdp.core.repository.SqliteConsentRepository(dbConnection);
        DataPrincipalRightsManager.DataRepository dataRepo = new com.neurq.dpdp.core.repository.SqliteDataRepository(dbConnection);
        DataPrincipalRightsManager.GrievanceRepository grievanceRepo = new com.neurq.dpdp.core.repository.SqliteGrievanceRepository(dbConnection);
        DataPrincipalRightsManager.NomineeRepository nomineeRepo = new com.neurq.dpdp.core.repository.SqliteNomineeRepository(dbConnection);
        BreachNotificationManager.BreachRepository breachRepo = new com.neurq.dpdp.core.repository.SqliteBreachRepository(dbConnection);
        ComplianceScoringEngine.ComplianceRepository complianceRepo = new com.neurq.dpdp.core.repository.SqliteComplianceRepository(dbConnection);
        
        // Initialize managers
        consentManager = new ConsentManager(consentRepo);
        rightsManager = new DataPrincipalRightsManager(dataRepo, grievanceRepo, nomineeRepo);
        breachManager = new BreachNotificationManager(breachRepo);
        scoringEngine = new ComplianceScoringEngine(complianceRepo);
        
        // Set default language
        I18nManager.setLocale("en");
        
        // Create main UI
        primaryStage.setTitle("QS-DPDP Compliance Operating System");
        primaryStage.setWidth(1200);
        primaryStage.setHeight(800);
        
        BorderPane root = new BorderPane();
        
        // Menu bar
        MenuBar menuBar = createMenuBar();
        root.setTop(menuBar);
        
        // Main content area
        TabPane tabPane = createMainTabs();
        root.setCenter(tabPane);
        
        // Status bar
        Label statusBar = new Label("Ready | License: " + licenseResult.getLicense().getType());
        root.setBottom(statusBar);
        
        Scene scene = new Scene(root);
        primaryStage.setScene(scene);
        primaryStage.show();
    }
    
    private MenuBar createMenuBar() {
        MenuBar menuBar = new MenuBar();
        
        // File menu
        Menu fileMenu = new Menu(I18nManager.translate("menu.file"));
        MenuItem exitItem = new MenuItem(I18nManager.translate("menu.exit"));
        exitItem.setOnAction(e -> System.exit(0));
        fileMenu.getItems().add(exitItem);
        
        // Compliance menu
        Menu complianceMenu = new Menu(I18nManager.translate("menu.compliance"));
        MenuItem consentItem = new MenuItem(I18nManager.translate("menu.consent"));
        MenuItem rightsItem = new MenuItem(I18nManager.translate("menu.data_principal_rights"));
        MenuItem breachItem = new MenuItem(I18nManager.translate("menu.breach_notification"));
        MenuItem scoringItem = new MenuItem(I18nManager.translate("menu.compliance_scoring"));
        complianceMenu.getItems().addAll(consentItem, rightsItem, breachItem, scoringItem);
        
        // Help menu with AI Chatbot
        Menu helpMenu = new Menu(I18nManager.translate("menu.help"));
        MenuItem aiChatbotItem = new MenuItem(I18nManager.translate("menu.ai_chatbot"));
        aiChatbotItem.setOnAction(e -> openAiChatbot());
        MenuItem aboutItem = new MenuItem(I18nManager.translate("menu.about"));
        helpMenu.getItems().addAll(aiChatbotItem, aboutItem);
        
        menuBar.getMenus().addAll(fileMenu, complianceMenu, helpMenu);
        return menuBar;
    }
    
    private TabPane createMainTabs() {
        TabPane tabPane = new TabPane();
        
        // Consent Management Tab
        Tab consentTab = new Tab(I18nManager.translate("tab.consent"));
        consentTab.setContent(createConsentManagementUI());
        
        // Data Principal Rights Tab
        Tab rightsTab = new Tab(I18nManager.translate("tab.data_principal_rights"));
        rightsTab.setContent(createRightsManagementUI());
        
        // Breach Notification Tab
        Tab breachTab = new Tab(I18nManager.translate("tab.breach_notification"));
        breachTab.setContent(createBreachManagementUI());
        
        // Compliance Scoring Tab
        Tab scoringTab = new Tab(I18nManager.translate("tab.compliance_scoring"));
        scoringTab.setContent(createComplianceScoringUI());
        
        tabPane.getTabs().addAll(consentTab, rightsTab, breachTab, scoringTab);
        return tabPane;
    }
    
    private VBox createConsentManagementUI() {
        VBox vbox = new VBox(10);
        vbox.setPadding(new javafx.geometry.Insets(10));
        
        Label title = new Label("Consent Lifecycle Management");
        title.setStyle("-fx-font-size: 18px; -fx-font-weight: bold;");
        
        Button recordConsentBtn = new Button("Record Consent");
        recordConsentBtn.setOnAction(e -> showRecordConsentDialog());
        
        Button viewConsentsBtn = new Button("View Consents");
        viewConsentsBtn.setOnAction(e -> showConsentsList());
        
        vbox.getChildren().addAll(title, recordConsentBtn, viewConsentsBtn);
        return vbox;
    }
    
    private VBox createRightsManagementUI() {
        VBox vbox = new VBox(10);
        vbox.setPadding(new javafx.geometry.Insets(10));
        
        Label title = new Label("Data Principal Rights (Sections 11-15)");
        title.setStyle("-fx-font-size: 18px; -fx-font-weight: bold;");
        
        Button accessBtn = new Button("Right to Access");
        Button correctionBtn = new Button("Right to Correction");
        Button erasureBtn = new Button("Right to Erasure");
        Button grievanceBtn = new Button("Right to Grievance");
        Button portabilityBtn = new Button("Right to Data Portability");
        
        vbox.getChildren().addAll(title, accessBtn, correctionBtn, erasureBtn, grievanceBtn, portabilityBtn);
        return vbox;
    }
    
    private VBox createBreachManagementUI() {
        VBox vbox = new VBox(10);
        vbox.setPadding(new javafx.geometry.Insets(10));
        
        Label title = new Label("Breach Notification (72-hour SLA)");
        title.setStyle("-fx-font-size: 18px; -fx-font-weight: bold;");
        
        Button reportBreachBtn = new Button("Report Breach");
        reportBreachBtn.setOnAction(e -> showBreachReportDialog());
        
        Button viewBreachesBtn = new Button("View Breach History");
        
        vbox.getChildren().addAll(title, reportBreachBtn, viewBreachesBtn);
        return vbox;
    }
    
    private VBox createComplianceScoringUI() {
        VBox vbox = new VBox(10);
        vbox.setPadding(new javafx.geometry.Insets(10));
        
        Label title = new Label("Compliance Scoring");
        title.setStyle("-fx-font-size: 18px; -fx-font-weight: bold;");
        
        Button calculateScoreBtn = new Button("Calculate Compliance Score");
        calculateScoreBtn.setOnAction(e -> calculateAndDisplayScore());
        
        Label scoreLabel = new Label("Score: --");
        scoreLabel.setId("scoreLabel");
        
        vbox.getChildren().addAll(title, calculateScoreBtn, scoreLabel);
        return vbox;
    }
    
    private void showRecordConsentDialog() {
        Dialog<ConsentManager.Consent> dialog = new Dialog<>();
        dialog.setTitle("Record Consent");
        dialog.setHeaderText("Record consent from data principal");
        
        // Add form fields
        TextField dataPrincipalIdField = new TextField();
        TextField purposeField = new TextField();
        ComboBox<ConsentManager.ConsentType> typeCombo = new ComboBox<>();
        typeCombo.getItems().addAll(ConsentManager.ConsentType.values());
        
        GridPane grid = new GridPane();
        grid.add(new Label("Data Principal ID:"), 0, 0);
        grid.add(dataPrincipalIdField, 1, 0);
        grid.add(new Label("Purpose:"), 0, 1);
        grid.add(purposeField, 1, 1);
        grid.add(new Label("Consent Type:"), 0, 2);
        grid.add(typeCombo, 1, 2);
        
        dialog.getDialogPane().setContent(grid);
        dialog.getDialogPane().getButtonTypes().addAll(ButtonType.OK, ButtonType.CANCEL);
        
        dialog.setResultConverter(dialogButton -> {
            if (dialogButton == ButtonType.OK) {
                return consentManager.recordConsent(
                    dataPrincipalIdField.getText(),
                    purposeField.getText(),
                    "PERSONAL_DATA",
                    typeCombo.getValue()
                );
            }
            return null;
        });
        
        dialog.showAndWait();
    }
    
    private void showConsentsList() {
        // Show consents in a table view
    }
    
    private void showBreachReportDialog() {
        Dialog<BreachNotificationManager.BreachIncident> dialog = new Dialog<>();
        dialog.setTitle("Report Breach");
        dialog.setHeaderText("Report data breach incident");
        
        TextArea descriptionArea = new TextArea();
        descriptionArea.setPrefRowCount(5);
        
        VBox vbox = new VBox(10);
        vbox.getChildren().addAll(new Label("Description:"), descriptionArea);
        
        dialog.getDialogPane().setContent(vbox);
        dialog.getDialogPane().getButtonTypes().addAll(ButtonType.OK, ButtonType.CANCEL);
        
        dialog.setResultConverter(dialogButton -> {
            if (dialogButton == ButtonType.OK) {
                BreachNotificationManager.BreachIncident incident = 
                    new BreachNotificationManager.BreachIncident();
                incident.setDescription(descriptionArea.getText());
                incident.setAffectedDataPrincipals(java.util.Collections.emptySet());
                incident.setAffectedDataCategories(java.util.Collections.emptySet());
                
                breachManager.notifyBreach(incident);
                return incident;
            }
            return null;
        });
        
        dialog.showAndWait();
    }
    
    private void calculateAndDisplayScore() {
        ComplianceScoringEngine.ComplianceScore score = 
            scoringEngine.calculateComplianceScore("ORG-001");
        
        // Update UI with score
        javafx.application.Platform.runLater(() -> {
            Label scoreLabel = (Label) javafx.scene.Scene.getCurrent().lookup("#scoreLabel");
            if (scoreLabel != null) {
                scoreLabel.setText(String.format("Score: %.1f%% - %s", 
                    score.getOverallScore(), score.getGrade()));
            }
        });
    }
    
    private void openAiChatbot() {
        Stage chatbotStage = new Stage();
        chatbotStage.setTitle("AI Compliance Assistant");
        chatbotStage.setWidth(600);
        chatbotStage.setHeight(500);
        
        VBox vbox = new VBox(10);
        vbox.setPadding(new javafx.geometry.Insets(10));
        
        TextArea chatArea = new TextArea();
        chatArea.setEditable(false);
        chatArea.setPrefRowCount(20);
        
        TextField inputField = new TextField();
        inputField.setPromptText("Ask about DPDP compliance...");
        
        Button sendBtn = new Button("Send");
        sendBtn.setOnAction(e -> {
            String question = inputField.getText();
            chatArea.appendText("You: " + question + "\n");
            // Call RAG system
            String answer = "AI Response: " + question; // Placeholder
            chatArea.appendText(answer + "\n\n");
            inputField.clear();
        });
        
        HBox inputBox = new HBox(10);
        inputBox.getChildren().addAll(inputField, sendBtn);
        
        vbox.getChildren().addAll(chatArea, inputBox);
        
        Scene scene = new Scene(vbox);
        chatbotStage.setScene(scene);
        chatbotStage.show();
    }
    
    private void showLicenseError(Stage stage, String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle("License Error");
        alert.setHeaderText("License validation failed");
        alert.setContentText(message);
        alert.showAndWait();
        System.exit(1);
    }
    
    private java.sql.Connection initializeDatabase() {
        try {
            String dbPath = System.getProperty("user.home") + "/.qs-dpdp/database.db";
            java.io.File dbFile = new java.io.File(dbPath);
            dbFile.getParentFile().mkdirs();
            
            // Load SQLite JDBC driver
            Class.forName("org.sqlite.JDBC");
            
            String url = "jdbc:sqlite:" + dbPath;
            java.sql.Connection conn = java.sql.DriverManager.getConnection(url);
            
            return conn;
        } catch (Exception e) {
            // Fallback to in-memory if SQLite not available
            System.err.println("Warning: SQLite not available, using in-memory storage: " + e.getMessage());
            try {
                Class.forName("org.sqlite.JDBC");
                return java.sql.DriverManager.getConnection("jdbc:sqlite::memory:");
            } catch (Exception ex) {
                throw new RuntimeException("Failed to initialize database", ex);
            }
        }
    }
    
    @Deprecated
    private static class ConsentRepositoryImpl implements ConsentManager.ConsentRepository {
        private java.util.Map<String, ConsentManager.Consent> consents = new java.util.HashMap<>();
        
        @Override
        public void save(ConsentManager.Consent consent) {
            consents.put(consent.getId(), consent);
        }
        
        @Override
        public ConsentManager.Consent findById(String id) {
            return consents.get(id);
        }
        
        @Override
        public java.util.List<ConsentManager.Consent> findActiveByDataPrincipal(String dataPrincipalId) {
            return consents.values().stream()
                .filter(c -> c.getDataPrincipalId().equals(dataPrincipalId) && 
                            c.getStatus() == ConsentManager.ConsentStatus.ACTIVE)
                .collect(java.util.stream.Collectors.toList());
        }
        
        @Override
        public void update(ConsentManager.Consent consent) {
            consents.put(consent.getId(), consent);
        }
    }
    
    public static void main(String[] args) {
        launch(args);
    }
}
