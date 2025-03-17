package frames;

import app.App;
import material.*;
import utilities.Database;
import utilities.Theme;

import javax.swing.*;
import java.awt.*;
import java.sql.ResultSet;
import java.util.Objects;

public class DietPlan extends JFrame {
    private final String username;
    private final JPanel mainPanel;
    private String dietType;
    private String goal;

    public DietPlan(String username) {
        this.username = username;
        setTitle(App.getTitle() + " - Diet Plan");
        setIconImage(App.getIcon());
        
        mainPanel = new JPanel();
        mainPanel.setLayout(new BoxLayout(mainPanel, BoxLayout.Y_AXIS));
        mainPanel.setBackground(Color.WHITE);
        
        // Try to load existing preferences
        loadDietPreferences();
        
        // If no preferences exist, show the preferences form
        if (dietType == null || goal == null) {
            showPreferencesForm();
        } else {
            showDietPlan();
        }
        
        // Add scroll capability
        JScrollPane scrollPane = new MatScrollPane(mainPanel);
        add(scrollPane);
        
        setupWindow();
    }
    
    private void loadDietPreferences() {
        try {
            ResultSet rs = Database.executeQuery(
                "SELECT diet_type, goal FROM diet_preferences WHERE username = '" + username + "'"
            );
            if (rs != null && rs.next()) {
                dietType = rs.getString("diet_type");
                goal = rs.getString("goal");
            }
        } catch (Exception e) {
            Database.showError();
        }
    }
    
    private void showPreferencesForm() {
        mainPanel.removeAll();
        
        // Title
        JLabel title = new JLabel("Set Your Diet Preferences");
        title.setFont(App.getFont().deriveFont(24f));
        title.setForeground(Theme.DARK_BLUE.color);
        title.setAlignmentX(Component.CENTER_ALIGNMENT);
        mainPanel.add(Box.createVerticalStrut(20));
        mainPanel.add(title);
        mainPanel.add(Box.createVerticalStrut(20));
        
        // Diet Type Selection
        JPanel dietTypePanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        dietTypePanel.setBackground(Color.WHITE);
        JLabel dietLabel = new JLabel("Diet Type:");
        dietLabel.setFont(App.getFont().deriveFont(16f));
        String[] dietTypes = {"Vegetarian", "Non-Vegetarian"};
        MatComboBox<String> dietTypeCombo = new MatComboBox<>(dietTypes);
        dietTypePanel.add(dietLabel);
        dietTypePanel.add(dietTypeCombo);
        mainPanel.add(dietTypePanel);
        
        // Goal Selection
        JPanel goalPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        goalPanel.setBackground(Color.WHITE);
        JLabel goalLabel = new JLabel("Goal:");
        goalLabel.setFont(App.getFont().deriveFont(16f));
        String[] goals = {"Weight Loss", "Weight Gain", "Maintain"};
        MatComboBox<String> goalCombo = new MatComboBox<>(goals);
        goalPanel.add(goalLabel);
        goalPanel.add(goalCombo);
        mainPanel.add(goalPanel);
        
        // Save Button
        MatButton saveButton = new MatButton("Save Preferences");
        saveButton.setBackground(Theme.LIGHT_BLUE.color);
        saveButton.setForeground(Color.WHITE);
        saveButton.setAlignmentX(Component.CENTER_ALIGNMENT);
        mainPanel.add(Box.createVerticalStrut(20));
        mainPanel.add(saveButton);
        
        saveButton.addActionListener(e -> {
            try {
                String selectedDietType = (String) dietTypeCombo.getSelectedItem();
                String selectedGoal = (String) goalCombo.getSelectedItem();
                
                if (Objects.equals(selectedDietType, "Diet Type") || Objects.equals(selectedGoal, "Goal")) {
                    JOptionPane.showMessageDialog(this, "Please select both diet type and goal");
                    return;
                }
                
                // Save preferences to database
                Database.executeUpdate(
                    "INSERT INTO diet_preferences (username, diet_type, goal) " +
                    "VALUES ('" + username + "', '" + selectedDietType + "', '" + selectedGoal + "') " +
                    "ON DUPLICATE KEY UPDATE diet_type = '" + selectedDietType + "', goal = '" + selectedGoal + "'"
                );
                
                dietType = selectedDietType;
                goal = selectedGoal;
                showDietPlan();
            } catch (Exception ex) {
                Database.showError();
            }
        });
        
        mainPanel.revalidate();
        mainPanel.repaint();
    }
    
    private void showDietPlan() {
        mainPanel.removeAll();
        
        // Title
        JLabel title = new JLabel("Your Personalized Diet Plan");
        title.setFont(App.getFont().deriveFont(24f));
        title.setForeground(Theme.DARK_BLUE.color);
        title.setAlignmentX(Component.CENTER_ALIGNMENT);
        mainPanel.add(Box.createVerticalStrut(20));
        mainPanel.add(title);
        
        // Preferences display and edit button
        JPanel prefPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        prefPanel.setBackground(Color.WHITE);
        JLabel prefLabel = new JLabel(dietType + " | " + goal);
        prefLabel.setFont(App.getFont().deriveFont(16f));
        MatButton editButton = new MatButton("Edit Preferences");
        editButton.addActionListener(e -> showPreferencesForm());
        prefPanel.add(prefLabel);
        prefPanel.add(editButton);
        mainPanel.add(prefPanel);
        mainPanel.add(Box.createVerticalStrut(20));
        
        try {
            // Get diet plans from database
            ResultSet rs = Database.executeQuery(
                "SELECT * FROM diet_plans " +
                "WHERE diet_type = '" + dietType + "' " +
                "AND goal = '" + goal + "' " +
                "ORDER BY FIELD(meal_time, 'Breakfast', 'Lunch', 'Snack', 'Dinner')"
            );
            
            if (rs != null) {
                String currentMealTime = "";
                while (rs.next()) {
                    String mealTime = rs.getString("meal_time");
                    
                    // Add meal time header if it's a new meal time
                    if (!mealTime.equals(currentMealTime)) {
                        JLabel mealLabel = new JLabel(mealTime);
                        mealLabel.setFont(App.getFont().deriveFont(20f));
                        mealLabel.setForeground(Theme.LIGHT_BLUE.color);
                        mealLabel.setAlignmentX(Component.CENTER_ALIGNMENT);
                        mainPanel.add(Box.createVerticalStrut(20));
                        mainPanel.add(mealLabel);
                        currentMealTime = mealTime;
                    }
                    
                    // Create meal panel
                    JPanel mealPanel = new JPanel();
                    mealPanel.setLayout(new BoxLayout(mealPanel, BoxLayout.Y_AXIS));
                    mealPanel.setBackground(Color.WHITE);
                    mealPanel.setBorder(BorderFactory.createLineBorder(Theme.LIGHT_BLUE.color));
                    mealPanel.setMaximumSize(new Dimension(400, 150));
                    mealPanel.setAlignmentX(Component.CENTER_ALIGNMENT);
                    
                    // Add food items
                    JLabel foodLabel = new JLabel(rs.getString("food_items"));
                    foodLabel.setFont(App.getFont().deriveFont(16f));
                    foodLabel.setAlignmentX(Component.CENTER_ALIGNMENT);
                    mealPanel.add(Box.createVerticalStrut(10));
                    mealPanel.add(foodLabel);
                    
                    // Add nutritional info
                    JPanel nutritionPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
                    nutritionPanel.setBackground(Color.WHITE);
                    nutritionPanel.add(new JLabel(String.format("Calories: %d", rs.getInt("calories"))));
                    nutritionPanel.add(new JLabel(" | "));
                    nutritionPanel.add(new JLabel(String.format("Protein: %dg", rs.getInt("protein"))));
                    nutritionPanel.add(new JLabel(" | "));
                    nutritionPanel.add(new JLabel(String.format("Carbs: %dg", rs.getInt("carbs"))));
                    nutritionPanel.add(new JLabel(" | "));
                    nutritionPanel.add(new JLabel(String.format("Fats: %dg", rs.getInt("fats"))));
                    mealPanel.add(nutritionPanel);
                    mealPanel.add(Box.createVerticalStrut(10));
                    
                    mainPanel.add(Box.createVerticalStrut(10));
                    mainPanel.add(mealPanel);
                }
            }
        } catch (Exception e) {
            Database.showError();
        }
        
        mainPanel.revalidate();
        mainPanel.repaint();
    }
    
    private void setupWindow() {
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);
        setSize(500, 700);
        setLocationRelativeTo(null);
        setVisible(true);
    }
} 