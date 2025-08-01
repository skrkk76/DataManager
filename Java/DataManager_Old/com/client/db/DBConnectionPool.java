package com.client.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Vector;

import com.client.license.EncryptDecrypt;
import com.client.license.VerifyLicense;
import com.client.util.RDMServicesConstants.ALGORITHM;
import com.client.util.RDMServicesUtils;

public class DBConnectionPool implements Runnable {
    private static String driver, url, username, password;
    private static final int maxConnections = 50;
    private static Vector<Connection> availableConnections = new Vector<Connection>();
    private static Vector<Connection> busyConnections = new Vector<Connection>();
    private static boolean connectionPending = false;
    private static boolean initialized = false;

    public DBConnectionPool() throws Exception {
	if (!initialized) {
	    boolean licensed = VerifyLicense.verifyLicense();
	    if (licensed) {
		driver = RDMServicesUtils.getProperty("rdmservices.db.driver");
		url = RDMServicesUtils.getProperty("rdmservices.db.url");
		username = RDMServicesUtils.getProperty("rdmservices.db.user");
		password = new EncryptDecrypt().decrypt(RDMServicesUtils.getDBPassword(), ALGORITHM.DES);
		initialized = true;
	    }
	}
    }

    public synchronized Connection getConnection() throws SQLException, InterruptedException {
	try {
	    if (!availableConnections.isEmpty() && (availableConnections.size() > 0)) {
		int idx = availableConnections.size() - 1;
		Connection existingConnection = (Connection) availableConnections.elementAt(idx);
		if (existingConnection == null) {
		    notifyAll();
		    this.wait(1000);
		    return getConnection();
		} else {
		    if (existingConnection.isClosed()) {
			notifyAll();
			this.wait(1000);
			return getConnection();
		    } else {
			busyConnections.addElement(existingConnection);
			if (availableConnections.size() > idx) {
			    availableConnections.removeElementAt(idx);
			}
			notifyAll();
			return existingConnection;
		    }
		}
	    } else {
		if ((totalConnections() < maxConnections) && !connectionPending) {
		    makeBackgroundConnection();
		}

		notifyAll();
		this.wait(1000);
		return getConnection();
	    }
	} catch (InterruptedException ine) {
	    ine.printStackTrace(System.out);
	    throw ine;
	} catch (SQLException sql) {
	    sql.printStackTrace(System.out);
	    throw sql;
	}
    }

    private void makeBackgroundConnection() {
	connectionPending = true;
	try {
	    Thread connectThread = new Thread(this);
	    connectThread.start();
	} catch (OutOfMemoryError oome) {
	    oome.printStackTrace(System.out);
	    throw oome;
	}
    }

    public void run() {
	try {
	    synchronized (this) {
		availableConnections.addElement(makeNewConnection());
		connectionPending = false;
		notifyAll();
	    }
	} catch (Exception e) {
	    e.printStackTrace(System.out);
	}
    }

    private Connection makeNewConnection() throws SQLException {
	try {
	    Class.forName(driver);
	    Connection connection = DriverManager.getConnection(url, username, password);
	    return (connection);
	} catch (ClassNotFoundException cnfe) {
	    cnfe.printStackTrace(System.out);
	    throw new SQLException("Can't find class for driver: " + driver);
	}
    }

    public synchronized void free(Connection connection) {
	if (connection != null) {
	    availableConnections.addElement(connection);
	    busyConnections.removeElement(connection);
	    notifyAll();
	}
    }

    public synchronized int totalConnections() {
	return (availableConnections.size() + busyConnections.size());
    }

    public synchronized void closeAllConnections() throws SQLException {
	closeConnections(availableConnections);
	availableConnections = new Vector<Connection>();
	closeConnections(busyConnections);
	busyConnections = new Vector<Connection>();
    }

    private void closeConnections(Vector<Connection> connections) throws SQLException {
	try {
	    for (int i = 0; i < connections.size(); i++) {
		Connection connection = connections.elementAt(i);
		if (!connection.isClosed()) {
		    connection.close();
		}
	    }
	} catch (SQLException sqle) {
	    sqle.printStackTrace(System.out);
	    throw sqle;
	}
    }

    public synchronized String toString() {
	String info = "ConnectionPool(" + url + "," + username + ")" + ", available=" + availableConnections.size()
		+ ", busy=" + busyConnections.size() + ", max=" + maxConnections;
	return (info);
    }
}
