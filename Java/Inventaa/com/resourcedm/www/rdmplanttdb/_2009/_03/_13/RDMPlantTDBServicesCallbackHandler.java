
/**
 * RDMPlantTDBServicesCallbackHandler.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.1  Built on : Aug 31, 2011 (12:22:40 CEST)
 */

    package com.resourcedm.www.rdmplanttdb._2009._03._13;

    /**
     *  RDMPlantTDBServicesCallbackHandler Callback class, Users can extend this class and implement
     *  their own receiveResult and receiveError methods.
     */
    public abstract class RDMPlantTDBServicesCallbackHandler{



    protected Object clientData;

    /**
    * User can pass in any object that needs to be accessed once the NonBlocking
    * Web service call is finished and appropriate method of this CallBack is called.
    * @param clientData Object mechanism by which the user can pass in user data
    * that will be avilable at the time this callback is called.
    */
    public RDMPlantTDBServicesCallbackHandler(Object clientData){
        this.clientData = clientData;
    }

    /**
    * Please use this constructor if you don't want to set any clientData
    */
    public RDMPlantTDBServicesCallbackHandler(){
        this.clientData = null;
    }

    /**
     * Get the client data
     */

     public Object getClientData() {
        return clientData;
     }

        
           /**
            * auto generated Axis2 call back method for getSlave method
            * override this method for handling normal response from getSlave operation
            */
           public void receiveResultgetSlave(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getSlave operation
           */
            public void receiveErrorgetSlave(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getLogDataInline method
            * override this method for handling normal response from getLogDataInline operation
            */
           public void receiveResultgetLogDataInline(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInlineResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getLogDataInline operation
           */
            public void receiveErrorgetLogDataInline(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getGPTimerChannels method
            * override this method for handling normal response from getGPTimerChannels operation
            */
           public void receiveResultgetGPTimerChannels(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelsResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getGPTimerChannels operation
           */
            public void receiveErrorgetGPTimerChannels(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getLogItemInline method
            * override this method for handling normal response from getLogItemInline operation
            */
           public void receiveResultgetLogItemInline(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInlineResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getLogItemInline operation
           */
            public void receiveErrorgetLogItemInline(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getTDBInfo method
            * override this method for handling normal response from getTDBInfo operation
            */
           public void receiveResultgetTDBInfo(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfoResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getTDBInfo operation
           */
            public void receiveErrorgetTDBInfo(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getLogItem method
            * override this method for handling normal response from getLogItem operation
            */
           public void receiveResultgetLogItem(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getLogItem operation
           */
            public void receiveErrorgetLogItem(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getVersion method
            * override this method for handling normal response from getVersion operation
            */
           public void receiveResultgetVersion(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersionResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getVersion operation
           */
            public void receiveErrorgetVersion(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for setSlave method
            * override this method for handling normal response from setSlave operation
            */
           public void receiveResultsetSlave(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlaveResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from setSlave operation
           */
            public void receiveErrorsetSlave(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getGPTimerChannel method
            * override this method for handling normal response from getGPTimerChannel operation
            */
           public void receiveResultgetGPTimerChannel(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getGPTimerChannel operation
           */
            public void receiveErrorgetGPTimerChannel(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getAlarmList method
            * override this method for handling normal response from getAlarmList operation
            */
           public void receiveResultgetAlarmList(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmListResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getAlarmList operation
           */
            public void receiveErrorgetAlarmList(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getSyslog method
            * override this method for handling normal response from getSyslog operation
            */
           public void receiveResultgetSyslog(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslogResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getSyslog operation
           */
            public void receiveErrorgetSyslog(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for setGPTimerChannel method
            * override this method for handling normal response from setGPTimerChannel operation
            */
           public void receiveResultsetGPTimerChannel(
                    com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannelResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from setGPTimerChannel operation
           */
            public void receiveErrorsetGPTimerChannel(java.lang.Exception e) {
            }
                


    }
    