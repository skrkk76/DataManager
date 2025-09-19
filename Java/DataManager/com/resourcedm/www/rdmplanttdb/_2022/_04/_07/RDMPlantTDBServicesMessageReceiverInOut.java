
/**
 * RDMPlantTDBServicesMessageReceiverInOut.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.1  Built on : Aug 31, 2011 (12:22:40 CEST)
 */
        package com.resourcedm.www.rdmplanttdb._2022._04._07;

        /**
        *  RDMPlantTDBServicesMessageReceiverInOut message receiver
        */

        public class RDMPlantTDBServicesMessageReceiverInOut extends org.apache.axis2.receivers.AbstractInOutMessageReceiver{


        public void invokeBusinessLogic(org.apache.axis2.context.MessageContext msgContext, org.apache.axis2.context.MessageContext newMsgContext)
        throws org.apache.axis2.AxisFault{

        try {

        // get the implementation class for the Web Service
        Object obj = getTheImplementationObject(msgContext);

        RDMPlantTDBServicesSoapImpl skel = (RDMPlantTDBServicesSoapImpl)obj;
        //Out Envelop
        org.apache.axiom.soap.SOAPEnvelope envelope = null;
        //Find the axisOperation that has been set by the Dispatch phase.
        org.apache.axis2.description.AxisOperation op = msgContext.getOperationContext().getAxisOperation();
        if (op == null) {
        throw new org.apache.axis2.AxisFault("Operation is not located, if this is doclit style the SOAP-ACTION should specified via the SOAP Action to use the RawXMLProvider");
        }

        java.lang.String methodName;
        if((op.getName() != null) && ((methodName = org.apache.axis2.util.JavaUtils.xmlNameToJavaIdentifier(op.getName().getLocalPart())) != null)){


        

            if("setGPTimerChannel".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannelResponse setGPTimerChannelResponse72 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannel wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannel)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannel.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        setGPTimerChannelResponse72 =
                                                                 skel.setGPTimerChannel(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), setGPTimerChannelResponse72, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "setGPTimerChannel"));
                                    } else 

            if("getGPTimerChannel".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelResponse getGPTimerChannelResponse74 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannel wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannel)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannel.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getGPTimerChannelResponse74 =
                                                                 skel.getGPTimerChannel(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getGPTimerChannelResponse74, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "getGPTimerChannel"));
                                    } else 

            if("getLogDataInline".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInlineResponse getLogDataInlineResponse76 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInline wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInline)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInline.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getLogDataInlineResponse76 =
                                                                 skel.getLogDataInline(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getLogDataInlineResponse76, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "getLogDataInline"));
                                    } else 

            if("getTDBInfo".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfoResponse getTDBInfoResponse78 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfo wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfo)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfo.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getTDBInfoResponse78 =
                                                                 skel.getTDBInfo(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getTDBInfoResponse78, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "getTDBInfo"));
                                    } else 

            if("getSyslog".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslogResponse getSyslogResponse81 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslog wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslog)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslog.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getSyslogResponse81 =
                                                                 skel.getSyslog(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getSyslogResponse81, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "getSyslog"));
                                    } else 

            if("getLogItemInline".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInlineResponse getLogItemInlineResponse83 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInline wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInline)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInline.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getLogItemInlineResponse83 =
                                                                 skel.getLogItemInline(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getLogItemInlineResponse83, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "getLogItemInline"));
                                    } else 

            if("getGPTimerChannels".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelsResponse getGPTimerChannelsResponse85 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannels wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannels)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannels.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getGPTimerChannelsResponse85 =
                                                                 skel.getGPTimerChannels(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getGPTimerChannelsResponse85, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "getGPTimerChannels"));
                                    } else 

            if("getSlave".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlaveResponse getSlaveResponse87 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlave wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlave)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlave.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getSlaveResponse87 =
                                                                 skel.getSlave(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getSlaveResponse87, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "getSlave"));
                                    } else 

            if("overrideGPTimerChannel".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannelResponse overrideGPTimerChannelResponse90 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannel wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannel)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannel.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        overrideGPTimerChannelResponse90 =
                                                                 skel.overrideGPTimerChannel(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), overrideGPTimerChannelResponse90, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "overrideGPTimerChannel"));
                                    } else 

            if("setSlave".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlaveResponse setSlaveResponse93 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlave wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlave)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlave.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        setSlaveResponse93 =
                                                                 skel.setSlave(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), setSlaveResponse93, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "setSlave"));
                                    } else 

            if("getLogItem".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemResponse getLogItemResponse95 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItem wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItem)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItem.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getLogItemResponse95 =
                                                                 skel.getLogItem(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getLogItemResponse95, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "getLogItem"));
                                    } else 

            if("getVersion".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersionResponse getVersionResponse97 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersion wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersion)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersion.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getVersionResponse97 =
                                                                 skel.getVersion(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getVersionResponse97, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "getVersion"));
                                    } else 

            if("getAlarmList".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmListResponse getAlarmListResponse99 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmList wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmList)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmList.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getAlarmListResponse99 =
                                                                 skel.getAlarmList(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getAlarmListResponse99, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "getAlarmList"));
                                    } else 

            if("cancelSlave".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlaveResponse cancelSlaveResponse102 = null;
	                        com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlave wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlave)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlave.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        cancelSlaveResponse102 =
                                                                 skel.cancelSlave(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), cancelSlaveResponse102, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                    "cancelSlave"));
                                    
            } else {
              throw new java.lang.RuntimeException("method not found");
            }
        

        newMsgContext.setEnvelope(envelope);
        }
        }
        catch (java.lang.Exception e) {
        throw org.apache.axis2.AxisFault.makeFault(e);
        }
        }
        
        //
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannel param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannel.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannelResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannelResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannel param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannel.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInline param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInline.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInlineResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInlineResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfo param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfo.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfoResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfoResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslog param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslog.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslogResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslogResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInline param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInline.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInlineResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInlineResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannels param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannels.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelsResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelsResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlave param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlave.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlaveResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlaveResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannel param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannel.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannelResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannelResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlave param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlave.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlaveResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlaveResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItem param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItem.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersion param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersion.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersionResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersionResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmList param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmList.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmListResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmListResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlave param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlave.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlaveResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlaveResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannelResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannelResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannelResponse wrapSetGPTimerChannel(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannelResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannelResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelResponse wrapGetGPTimerChannel(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInlineResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInlineResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInlineResponse wrapGetLogDataInline(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInlineResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInlineResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfoResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfoResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfoResponse wrapGetTDBInfo(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfoResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfoResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslogResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslogResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslogResponse wrapGetSyslog(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslogResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslogResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInlineResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInlineResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInlineResponse wrapGetLogItemInline(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInlineResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInlineResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelsResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelsResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelsResponse wrapGetGPTimerChannels(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelsResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelsResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlaveResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlaveResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlaveResponse wrapGetSlave(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlaveResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlaveResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannelResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannelResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannelResponse wrapOverrideGPTimerChannel(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannelResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannelResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlaveResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlaveResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlaveResponse wrapSetSlave(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlaveResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlaveResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemResponse wrapGetLogItem(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersionResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersionResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersionResponse wrapGetVersion(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersionResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersionResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmListResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmListResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmListResponse wrapGetAlarmList(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmListResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmListResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlaveResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlaveResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlaveResponse wrapCancelSlave(){
                                com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlaveResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlaveResponse();
                                return wrappedElement;
                         }
                    


        /**
        *  get the default envelope
        */
        private org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory){
        return factory.getDefaultEnvelope();
        }


        private  java.lang.Object fromOM(
        org.apache.axiom.om.OMElement param,
        java.lang.Class type,
        java.util.Map extraNamespaces) throws org.apache.axis2.AxisFault{

        try {
        
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannel.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannel.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannelResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.SetGPTimerChannelResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannel.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannel.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInline.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInline.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInlineResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogDataInlineResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfo.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfo.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfoResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetTDBInfoResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslog.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslog.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslogResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetSyslogResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInline.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInline.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInlineResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemInlineResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannels.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannels.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelsResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetGPTimerChannelsResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlave.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlave.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlaveResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetSlaveResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannel.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannel.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannelResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.OverrideGPTimerChannelResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlave.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlave.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlaveResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.SetSlaveResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItem.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItem.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetLogItemResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersion.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersion.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersionResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetVersionResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmList.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmList.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmListResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.GetAlarmListResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlave.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlave.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlaveResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.CancelSlaveResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2022._04._07.UserCredentialsE.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
        } catch (java.lang.Exception e) {
        throw org.apache.axis2.AxisFault.makeFault(e);
        }
           return null;
        }



    

        /**
        *  A utility method that copies the namepaces from the SOAPEnvelope
        */
        private java.util.Map getEnvelopeNamespaces(org.apache.axiom.soap.SOAPEnvelope env){
        java.util.Map returnMap = new java.util.HashMap();
        java.util.Iterator namespaceIterator = env.getAllDeclaredNamespaces();
        while (namespaceIterator.hasNext()) {
        org.apache.axiom.om.OMNamespace ns = (org.apache.axiom.om.OMNamespace) namespaceIterator.next();
        returnMap.put(ns.getPrefix(),ns.getNamespaceURI());
        }
        return returnMap;
        }

        private org.apache.axis2.AxisFault createAxisFault(java.lang.Exception e) {
        org.apache.axis2.AxisFault f;
        Throwable cause = e.getCause();
        if (cause != null) {
            f = new org.apache.axis2.AxisFault(e.getMessage(), cause);
        } else {
            f = new org.apache.axis2.AxisFault(e.getMessage());
        }

        return f;
    }

        }//end of class
    