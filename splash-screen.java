package com.neurq.dpdp.core;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.scene.Scene;
import javafx.scene.layout.StackPane;
import javafx.scene.web.WebView;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import java.io.File;

/**
 * Visual Studio-style Splash Screen
 * RAG AI-based Quantum Safe DPDP Compliance System
 */
public class SplashScreen extends Application {
    private static Stage splashStage;
    private static boolean splashClosed = false;
    
    @Override
    public void start(Stage primaryStage) {
        splashStage = primaryStage;
        
        // Create WebView to display HTML splash
        WebView webView = new WebView();
        
        // Load splash screen HTML
        File htmlFile = new File("splash-screen.html");
        if (htmlFile.exists()) {
            webView.getEngine().load(htmlFile.toURI().toString());
        } else {
            // Fallback: Create simple splash
            webView.getEngine().loadContent(createFallbackSplash());
        }
        
        StackPane root = new StackPane();
        root.getChildren().add(webView);
        
        Scene scene = new Scene(root, 600, 400);
        scene.setFill(null);
        
        primaryStage.setScene(scene);
        primaryStage.initStyle(StageStyle.TRANSPARENT);
        primaryStage.setTitle("QS-DPDP OS - Loading...");
        primaryStage.setAlwaysOnTop(true);
        primaryStage.centerOnScreen();
        primaryStage.show();
        
        // Auto-close after main app loads
        new Thread(() -> {
            try {
                Thread.sleep(3000); // Show for 3 seconds
                Platform.runLater(() -> {
                    if (!splashClosed) {
                        closeSplash();
                    }
                });
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }).start();
    }
    
    public static void closeSplash() {
        if (splashStage != null && !splashClosed) {
            Platform.runLater(() -> {
                splashStage.close();
                splashClosed = true;
            });
        }
    }
    
    public static void showSplash() {
        if (!splashClosed) {
            launch();
        }
    }
    
    private String createFallbackSplash() {
        return """
            <!DOCTYPE html>
            <html>
            <head>
                <style>
                    body {
                        margin: 0;
                        padding: 0;
                        font-family: 'Segoe UI', sans-serif;
                        background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #7e22ce 100%);
                        color: white;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        height: 100vh;
                    }
                    .logo { font-size: 72px; font-weight: bold; margin-bottom: 20px; }
                    .title { font-size: 24px; margin-bottom: 10px; }
                    .subtitle { font-size: 14px; opacity: 0.8; }
                    .loading { margin-top: 30px; }
                </style>
            </head>
            <body>
                <div class="logo">QS</div>
                <div class="title">DPDP OPERATING SYSTEM</div>
                <div class="subtitle">Quantum-Safe Compliance Platform</div>
                <div class="loading">Loading...</div>
            </body>
            </html>
            """;
    }
    
    public static void main(String[] args) {
        launch(args);
    }
}
