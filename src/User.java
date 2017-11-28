import java.sql.Array;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.sql.DataSource;

public class User {
	private String username;
	private String phoneNumber;
	private int income;
	private int agentID;

	public User() {
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public int getIncome() {
		return income;
	}

	public void setIncome(int income) {
		this.income = income;
	}

	public int getAgentID() {
		return agentID;
	}

	public void setAgentID(int agentID) {
		this.agentID = agentID;
	}

	public String toString() {
		return "Username: " + username + "\nPhone number: " + phoneNumber + "\nIncome: " + income + "\nAgentID: "
				+ agentID;
	}

	public boolean createUser(Connection connection) {
		try {
			PreparedStatement statement = connection.prepareStatement("INSERT INTO User values(?,?,?, NULL, NULL);");
			statement.setString(1, username);
			statement.setString(2, phoneNumber);
			statement.setInt(3, income);
			statement.executeUpdate();
			System.out.println("New user created successfully.");
		} catch (SQLException e) {
			System.out.println("Could not create new User.");
			// e.printStackTrace();
			return false;
		}
		return true;
	}

	public static User login(Connection connection, String username, String phoneNumber) {
		try {
			PreparedStatement statement = connection.prepareStatement("SELECT * FROM USER WHERE (userName = '"
					+ username + "' AND phoneNumber = '" + phoneNumber + "');");
			// statement.setString(0, username);
			// statement.setString(1, phoneNumber);
			ResultSet result = statement.executeQuery();
			if (!result.next()) {
				System.out.println("Invalid username/phone number.");
				return null;
			}
			User login = new User();
			login.setUsername(result.getString("userName"));
			login.setPhoneNumber(result.getString("phoneNumber"));
			login.setIncome(result.getInt("income"));
			login.setAgentID(result.getInt("agentID"));
			// System.out.println(login.toString());
			// userName VARCHAR(30), phoneNumber VARCHAR(10), income INT DEFAULT
			// 0, agentID INT, userID INT AUTO_INCREMENT,
			// System.out.println("Username: " + result.getString("userName") +
			// "\t phoneNumber: " + result.getString("phoneNumber"));
			return login;
		} catch (SQLException e) {
			System.out.println("Could not log in.");
			// System.out.println(e.getErrorCode());
			e.printStackTrace();
			return null;
		}
	}

	public boolean updateUserInfo(Connection connection, String username, String phoneNumber, int income,
			boolean deleteAgent) {
		try {
			PreparedStatement statement;
			if (deleteAgent) {
				statement = connection.prepareStatement(
						"UPDATE User SET userName = '" + username + "', phoneNumber = '" + phoneNumber + "', income = " + income + ", agentID = NULL WHERE username = " + this.username + "' AND phoneNumber = '" + this.phoneNumber + "';");
			} else {
				statement = connection.prepareStatement(
						"UPDATE User SET userName = '" + username + "', phoneNumber = '" + phoneNumber + "', income = " + income + " WHERE username = '" + this.username + "' AND phoneNumber = '" + this.phoneNumber + "';");
			}
//			statement.setString(1, username);
//			statement.setString(2, phoneNumber);
//			statement.setInt(3, income);
//			statement.setString(4, username);
//			statement.setString(5, phoneNumber);
			System.out.println("tuples affected: " + statement.executeUpdate());

			setUsername(username);
			setPhoneNumber(phoneNumber);
			setIncome(income);
			System.out.println("User information updated.");
		} catch (SQLException e) {
			System.out.println("Could not update user info.");
			// System.out.println(e.getErrorCode());
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	/**
	 * Delete "this" user from database
	 * @ param connection	database connection to perfome deletion
	 * @return	true if deleted successfully and false if deleting failed
	 */
	public boolean deleteThisUser(Connection connection) {
		return this.deleteUser(connection, this.username);
	}
	
	/**
	 * Delete user whose has username from parameter
	 * @param connection	database connection to perform deletion
	 * @param username		Username of user to be deleted
	 * @return	true if deleted successfully and false if deleting failed
	 */
	private boolean deleteUser(Connection connection, String username) {
		PreparedStatement preparedStatement = null;
		try {
			String sql = null;
		    sql = "DELETE FROM User " 
		    	+ "WHERE username=" + "?";
		    
		    preparedStatement = connection.prepareStatement(sql);
		    
		    // Set the username
		    preparedStatement.setString(1, username);
		    
		    // Execute deletion
		    preparedStatement.executeUpdate();
			System.out.println("User deleted");
		} catch (SQLException e) {
			System.out.println("Could not delete user");
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public static void main(String[] args) {
		User a = new User();
		a.setUsername("Solace");
		a.setIncome(60000);
		a.setPhoneNumber("5105172299");
		// a.createUser();
	}

}
