
/**
 * RDMPlantTDBServicesMessageReceiverInOut.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.1  Built on : Aug 31, 2011 (12:22:40 CEST)
 */
        package com.resourcedm.www.rdmplanttdb._2009._03._13;

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


        

            if("getSlave".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse getSlaveResponse3 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlave wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlave)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlave.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getSlaveResponse3 =
                                                                 skel.getSlave(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getSlaveResponse3, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "getSlave"));
                                    } else 

            if("getLogDataInline".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInlineResponse getLogDataInlineResponse5 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInline wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInline)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInline.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getLogDataInlineResponse5 =
                                                                 skel.getLogDataInline(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getLogDataInlineResponse5, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "getLogDataInline"));
                                    } else 

            if("getGPTimerChannels".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelsResponse getGPTimerChannelsResponse7 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannels wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannels)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannels.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getGPTimerChannelsResponse7 =
                                                                 skel.getGPTimerChannels(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getGPTimerChannelsResponse7, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "getGPTimerChannels"));
                                    } else 

            if("getLogItemInline".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInlineResponse getLogItemInlineResponse9 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInline wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInline)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInline.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getLogItemInlineResponse9 =
                                                                 skel.getLogItemInline(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getLogItemInlineResponse9, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "getLogItemInline"));
                                    } else 

            if("getTDBInfo".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfoResponse getTDBInfoResponse11 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfo wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfo)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfo.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getTDBInfoResponse11 =
                                                                 skel.getTDBInfo(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getTDBInfoResponse11, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "getTDBInfo"));
                                    } else 

            if("getLogItem".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemResponse getLogItemResponse13 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItem wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItem)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItem.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getLogItemResponse13 =
                                                                 skel.getLogItem(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getLogItemResponse13, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "getLogItem"));
                                    } else 

            if("getVersion".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersionResponse getVersionResponse15 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersion wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersion)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersion.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getVersionResponse15 =
                                                                 skel.getVersion(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getVersionResponse15, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "getVersion"));
                                    } else 

            if("setSlave".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlaveResponse setSlaveResponse18 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlave wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlave)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlave.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        setSlaveResponse18 =
                                                                 skel.setSlave(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), setSlaveResponse18, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "setSlave"));
                                    } else 

            if("getGPTimerChannel".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelResponse getGPTimerChannelResponse20 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannel wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannel)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannel.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getGPTimerChannelResponse20 =
                                                                 skel.getGPTimerChannel(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getGPTimerChannelResponse20, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "getGPTimerChannel"));
                                    } else 

            if("getAlarmList".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmListResponse getAlarmListResponse22 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmList wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmList)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmList.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getAlarmListResponse22 =
                                                                 skel.getAlarmList(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getAlarmListResponse22, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "getAlarmList"));
                                    } else 

            if("getSyslog".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslogResponse getSyslogResponse25 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslog wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslog)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslog.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        getSyslogResponse25 =
                                                                 skel.getSyslog(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), getSyslogResponse25, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "getSyslog"));
                                    } else 

            if("setGPTimerChannel".equals(methodName)){
                
                com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannelResponse setGPTimerChannelResponse28 = null;
	                        com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannel wrappedParam =
                                                                 (com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannel)fromOM(
                                                        msgContext.getEnvelope().getBody().getFirstElement(),
                                                        com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannel.class,
                                                        getEnvelopeNamespaces(msgContext.getEnvelope()));

                                                        setGPTimerChannelResponse28 =
                                                                 skel.setGPTimerChannel(wrappedParam);
                                                            
                                        envelope = toEnvelope(getSOAPFactory(msgContext), setGPTimerChannelResponse28, false, new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                    "setGPTimerChannel"));
                                    
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
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlave param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlave.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInline param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInline.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInlineResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInlineResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannels param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannels.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelsResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelsResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInline param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInline.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInlineResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInlineResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfo param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfo.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfoResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfoResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItem param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItem.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersion param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersion.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersionResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersionResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlave param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlave.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlaveResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlaveResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.UserCredentialsE param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.UserCredentialsE.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannel param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannel.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmList param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmList.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmListResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmListResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslog param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslog.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslogResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslogResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannel param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannel.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannelResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannelResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse wrapGetSlave(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInlineResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInlineResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInlineResponse wrapGetLogDataInline(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInlineResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInlineResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelsResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelsResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelsResponse wrapGetGPTimerChannels(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelsResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelsResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInlineResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInlineResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInlineResponse wrapGetLogItemInline(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInlineResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInlineResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfoResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfoResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfoResponse wrapGetTDBInfo(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfoResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfoResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemResponse wrapGetLogItem(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersionResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersionResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersionResponse wrapGetVersion(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersionResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersionResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlaveResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlaveResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlaveResponse wrapSetSlave(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlaveResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlaveResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelResponse wrapGetGPTimerChannel(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmListResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmListResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmListResponse wrapGetAlarmList(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmListResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmListResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslogResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslogResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslogResponse wrapGetSyslog(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslogResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslogResponse();
                                return wrappedElement;
                         }
                    
                    private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannelResponse param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                        throws org.apache.axis2.AxisFault{
                      try{
                          org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                           
                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannelResponse.MY_QNAME,factory));
                                

                         return emptyEnvelope;
                    } catch(org.apache.axis2.databinding.ADBException e){
                        throw org.apache.axis2.AxisFault.makeFault(e);
                    }
                    }
                    
                         private com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannelResponse wrapSetGPTimerChannel(){
                                com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannelResponse wrappedElement = new com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannelResponse();
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
        
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlave.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlave.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInline.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInline.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInlineResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogDataInlineResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannels.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannels.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelsResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelsResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInline.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInline.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInlineResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemInlineResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfo.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfo.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfoResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetTDBInfoResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItem.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItem.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetLogItemResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersion.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersion.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersionResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetVersionResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlave.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlave.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlaveResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.SetSlaveResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.UserCredentialsE.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.UserCredentialsE.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannel.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannel.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetGPTimerChannelResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmList.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmList.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmListResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetAlarmListResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslog.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslog.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslogResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.GetSyslogResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.UserCredentialsE.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.UserCredentialsE.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannel.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannel.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannelResponse.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.SetGPTimerChannelResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.resourcedm.www.rdmplanttdb._2009._03._13.UserCredentialsE.class.equals(type)){
                
                           return com.resourcedm.www.rdmplanttdb._2009._03._13.UserCredentialsE.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

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
    