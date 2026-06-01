package com.senhostel.util;

import com.senhostel.dao.RealtimeDAO;
import com.senhostel.model.LiveDashboardStats;
import com.senhostel.websocket.LiveDashboardSocket;

public class RealtimeNotifier {

    public static void broadcastDashboardUpdate(String eventType, String message) {
        try {
            RealtimeDAO dao = new RealtimeDAO();
            LiveDashboardStats stats = dao.getDashboardStats();

            String json = "{"
                    + "\"eventType\":\"" + escape(eventType) + "\","
                    + "\"message\":\"" + escape(message) + "\","
                    + "\"totalRooms\":" + stats.getTotalRooms() + ","
                    + "\"availableRooms\":" + stats.getAvailableRooms() + ","
                    + "\"fullRooms\":" + stats.getFullRooms() + ","
                    + "\"maintenanceRooms\":" + stats.getMaintenanceRooms() + ","
                    + "\"totalBeds\":" + stats.getTotalBeds() + ","
                    + "\"occupiedBeds\":" + stats.getOccupiedBeds() + ","
                    + "\"vacantBeds\":" + stats.getVacantBeds() + ","
                    + "\"totalRoomMonthlyFee\":" + stats.getTotalRoomMonthlyFee() + ","
                    + "\"averageRoomMonthlyFee\":" + stats.getAverageRoomMonthlyFee() + ","
                    + "\"feePlansCount\":" + stats.getFeePlansCount() + ","
                    + "\"totalFeeStructureAmount\":" + stats.getTotalFeeStructureAmount() + ","
                    + "\"averageFeeStructureAmount\":" + stats.getAverageFeeStructureAmount() + ","
                    + "\"highestFee\":" + stats.getHighestFee() + ","
                    + "\"lowestFee\":" + stats.getLowestFee() + ","
                    + "\"lastUpdated\":\"" + escape(stats.getLastUpdated()) + "\","
                    + "\"onlineViewers\":" + LiveDashboardSocket.getOnlineCount()
                    + "}";

            LiveDashboardSocket.broadcast(json);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String escape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
