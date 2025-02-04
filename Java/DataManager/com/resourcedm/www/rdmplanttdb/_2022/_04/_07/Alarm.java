
/**
 * Alarm.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.1  Built on : Aug 31, 2011 (12:23:23 CEST)
 */

            
                package com.resourcedm.www.rdmplanttdb._2022._04._07;
            

            /**
            *  Alarm bean class
            */
            @SuppressWarnings({"unchecked","unused"})
        
        public  class Alarm
        implements org.apache.axis2.databinding.ADBBean{
        /* This type was generated from the piece of schema that had
                name = Alarm
                Namespace URI = http://www.resourcedm.com/RDMPlantTDB/2022/04/07/
                Namespace Prefix = ns1
                */
            

                        /**
                        * field for Serial
                        */

                        
                                    protected java.lang.String localSerial ;
                                

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getSerial(){
                               return localSerial;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Serial
                               */
                               public void setSerial(java.lang.String param){
                            
                                            this.localSerial=param;
                                    

                               }
                            

                        /**
                        * field for Text
                        */

                        
                                    protected java.lang.String localText ;
                                

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getText(){
                               return localText;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Text
                               */
                               public void setText(java.lang.String param){
                            
                                            this.localText=param;
                                    

                               }
                            

                        /**
                        * field for Occurred
                        */

                        
                                    protected java.util.Calendar localOccurred ;
                                

                           /**
                           * Auto generated getter method
                           * @return java.util.Calendar
                           */
                           public  java.util.Calendar getOccurred(){
                               return localOccurred;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Occurred
                               */
                               public void setOccurred(java.util.Calendar param){
                            
                                            this.localOccurred=param;
                                    

                               }
                            

                        /**
                        * field for Accepted
                        */

                        
                                    protected java.util.Calendar localAccepted ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localAcceptedTracker = false ;

                           public boolean isAcceptedSpecified(){
                               return localAcceptedTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.util.Calendar
                           */
                           public  java.util.Calendar getAccepted(){
                               return localAccepted;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Accepted
                               */
                               public void setAccepted(java.util.Calendar param){
                            localAcceptedTracker = param != null;
                                   
                                            this.localAccepted=param;
                                    

                               }
                            

                        /**
                        * field for AcceptedBy
                        */

                        
                                    protected java.lang.String localAcceptedBy ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localAcceptedByTracker = false ;

                           public boolean isAcceptedBySpecified(){
                               return localAcceptedByTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getAcceptedBy(){
                               return localAcceptedBy;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param AcceptedBy
                               */
                               public void setAcceptedBy(java.lang.String param){
                            localAcceptedByTracker = param != null;
                                   
                                            this.localAcceptedBy=param;
                                    

                               }
                            

                        /**
                        * field for Cleared
                        */

                        
                                    protected java.util.Calendar localCleared ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localClearedTracker = false ;

                           public boolean isClearedSpecified(){
                               return localClearedTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.util.Calendar
                           */
                           public  java.util.Calendar getCleared(){
                               return localCleared;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Cleared
                               */
                               public void setCleared(java.util.Calendar param){
                            localClearedTracker = param != null;
                                   
                                            this.localCleared=param;
                                    

                               }
                            

     
     
        /**
        *
        * @param parentQName
        * @param factory
        * @return org.apache.axiom.om.OMElement
        */
       public org.apache.axiom.om.OMElement getOMElement (
               final javax.xml.namespace.QName parentQName,
               final org.apache.axiom.om.OMFactory factory) throws org.apache.axis2.databinding.ADBException{


        
               org.apache.axiom.om.OMDataSource dataSource =
                       new org.apache.axis2.databinding.ADBDataSource(this,parentQName);
               return factory.createOMElement(dataSource,parentQName);
            
        }

         public void serialize(final javax.xml.namespace.QName parentQName,
                                       javax.xml.stream.XMLStreamWriter xmlWriter)
                                throws javax.xml.stream.XMLStreamException, org.apache.axis2.databinding.ADBException{
                           serialize(parentQName,xmlWriter,false);
         }

         public void serialize(final javax.xml.namespace.QName parentQName,
                               javax.xml.stream.XMLStreamWriter xmlWriter,
                               boolean serializeType)
            throws javax.xml.stream.XMLStreamException, org.apache.axis2.databinding.ADBException{
            
                


                java.lang.String prefix = null;
                java.lang.String namespace = null;
                

                    prefix = parentQName.getPrefix();
                    namespace = parentQName.getNamespaceURI();
                    writeStartElement(prefix, namespace, parentQName.getLocalPart(), xmlWriter);
                
                  if (serializeType){
               

                   java.lang.String namespacePrefix = registerPrefix(xmlWriter,"http://www.resourcedm.com/RDMPlantTDB/2022/04/07/");
                   if ((namespacePrefix != null) && (namespacePrefix.trim().length() > 0)){
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           namespacePrefix+":Alarm",
                           xmlWriter);
                   } else {
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           "Alarm",
                           xmlWriter);
                   }

               
                   }
               
                                    namespace = "http://www.resourcedm.com/RDMPlantTDB/2022/04/07/";
                                    writeStartElement(null, namespace, "Serial", xmlWriter);
                             

                                          if (localSerial==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("Serial cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localSerial);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             
                                    namespace = "http://www.resourcedm.com/RDMPlantTDB/2022/04/07/";
                                    writeStartElement(null, namespace, "Text", xmlWriter);
                             

                                          if (localText==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("Text cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localText);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             
                                    namespace = "http://www.resourcedm.com/RDMPlantTDB/2022/04/07/";
                                    writeStartElement(null, namespace, "Occurred", xmlWriter);
                             

                                          if (localOccurred==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("Occurred cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localOccurred));
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                              if (localAcceptedTracker){
                                    namespace = "http://www.resourcedm.com/RDMPlantTDB/2022/04/07/";
                                    writeStartElement(null, namespace, "Accepted", xmlWriter);
                             

                                          if (localAccepted==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("Accepted cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localAccepted));
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localAcceptedByTracker){
                                    namespace = "http://www.resourcedm.com/RDMPlantTDB/2022/04/07/";
                                    writeStartElement(null, namespace, "AcceptedBy", xmlWriter);
                             

                                          if (localAcceptedBy==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("AcceptedBy cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localAcceptedBy);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localClearedTracker){
                                    namespace = "http://www.resourcedm.com/RDMPlantTDB/2022/04/07/";
                                    writeStartElement(null, namespace, "Cleared", xmlWriter);
                             

                                          if (localCleared==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("Cleared cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localCleared));
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             }
                    xmlWriter.writeEndElement();
               

        }

        private static java.lang.String generatePrefix(java.lang.String namespace) {
            if(namespace.equals("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/")){
                return "ns1";
            }
            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix, java.lang.String namespace, java.lang.String localPart,
                                       javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {
            java.lang.String writerPrefix = xmlWriter.getPrefix(namespace);
            if (writerPrefix != null) {
                xmlWriter.writeStartElement(namespace, localPart);
            } else {
                if (namespace.length() == 0) {
                    prefix = "";
                } else if (prefix == null) {
                    prefix = generatePrefix(namespace);
                }

                xmlWriter.writeStartElement(prefix, localPart, namespace);
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
        }
        
        /**
         * Util method to write an attribute with the ns prefix
         */
        private void writeAttribute(java.lang.String prefix,java.lang.String namespace,java.lang.String attName,
                                    java.lang.String attValue,javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException{
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
            xmlWriter.writeAttribute(namespace,attName,attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,java.lang.String attName,
                                    java.lang.String attValue,javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException{
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName,attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace,attName,attValue);
            }
        }


           /**
             * Util method to write an attribute without the ns prefix
             */
            private void writeQNameAttribute(java.lang.String namespace, java.lang.String attName,
                                             javax.xml.namespace.QName qname, javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {

                java.lang.String attributeNamespace = qname.getNamespaceURI();
                java.lang.String attributePrefix = xmlWriter.getPrefix(attributeNamespace);
                if (attributePrefix == null) {
                    attributePrefix = registerPrefix(xmlWriter, attributeNamespace);
                }
                java.lang.String attributeValue;
                if (attributePrefix.trim().length() > 0) {
                    attributeValue = attributePrefix + ":" + qname.getLocalPart();
                } else {
                    attributeValue = qname.getLocalPart();
                }

                if (namespace.equals("")) {
                    xmlWriter.writeAttribute(attName, attributeValue);
                } else {
                    registerPrefix(xmlWriter, namespace);
                    xmlWriter.writeAttribute(namespace, attName, attributeValue);
                }
            }
        /**
         *  method to handle Qnames
         */

        private void writeQName(javax.xml.namespace.QName qname,
                                javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();
            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);
                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix,namespaceURI);
                }

                if (prefix.trim().length() > 0){
                    xmlWriter.writeCharacters(prefix + ":" + org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
                }

            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
                                 javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {

            if (qnames != null) {
                // we have to store this data until last moment since it is not possible to write any
                // namespace data after writing the charactor data
                java.lang.StringBuffer stringToWrite = new java.lang.StringBuffer();
                java.lang.String namespaceURI = null;
                java.lang.String prefix = null;

                for (int i = 0; i < qnames.length; i++) {
                    if (i > 0) {
                        stringToWrite.append(" ");
                    }
                    namespaceURI = qnames[i].getNamespaceURI();
                    if (namespaceURI != null) {
                        prefix = xmlWriter.getPrefix(namespaceURI);
                        if ((prefix == null) || (prefix.length() == 0)) {
                            prefix = generatePrefix(namespaceURI);
                            xmlWriter.writeNamespace(prefix, namespaceURI);
                            xmlWriter.setPrefix(prefix,namespaceURI);
                        }

                        if (prefix.trim().length() > 0){
                            stringToWrite.append(prefix).append(":").append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                    }
                }
                xmlWriter.writeCharacters(stringToWrite.toString());
            }

        }


        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(javax.xml.stream.XMLStreamWriter xmlWriter, java.lang.String namespace) throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);
            if (prefix == null) {
                prefix = generatePrefix(namespace);
                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();
                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);
                    if (uri == null || uri.length() == 0) {
                        break;
                    }
                    prefix = org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
                }
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
            return prefix;
        }


  
        /**
        * databinding method to get an XML representation of this object
        *
        */
        public javax.xml.stream.XMLStreamReader getPullParser(javax.xml.namespace.QName qName)
                    throws org.apache.axis2.databinding.ADBException{


        
                 java.util.ArrayList elementList = new java.util.ArrayList();
                 java.util.ArrayList attribList = new java.util.ArrayList();

                
                                      elementList.add(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                                      "Serial"));
                                 
                                        if (localSerial != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localSerial));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("Serial cannot be null!!");
                                        }
                                    
                                      elementList.add(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                                      "Text"));
                                 
                                        if (localText != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localText));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("Text cannot be null!!");
                                        }
                                    
                                      elementList.add(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                                      "Occurred"));
                                 
                                        if (localOccurred != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localOccurred));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("Occurred cannot be null!!");
                                        }
                                     if (localAcceptedTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                                      "Accepted"));
                                 
                                        if (localAccepted != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localAccepted));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("Accepted cannot be null!!");
                                        }
                                    } if (localAcceptedByTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                                      "AcceptedBy"));
                                 
                                        if (localAcceptedBy != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localAcceptedBy));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("AcceptedBy cannot be null!!");
                                        }
                                    } if (localClearedTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/",
                                                                      "Cleared"));
                                 
                                        if (localCleared != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localCleared));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("Cleared cannot be null!!");
                                        }
                                    }

                return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName, elementList.toArray(), attribList.toArray());
            
            

        }

  

     /**
      *  Factory class that keeps the parse method
      */
    public static class Factory{

        
        

        /**
        * static method to create the object
        * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
        *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
        * Postcondition: If this object is an element, the reader is positioned at its end element
        *                If this object is a complex type, the reader is positioned at the end element of its outer element
        */
        public static Alarm parse(javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{
            Alarm object =
                new Alarm();

            int event;
            java.lang.String nillableValue = null;
            java.lang.String prefix ="";
            java.lang.String namespaceuri ="";
            try {
                
                while (!reader.isStartElement() && !reader.isEndElement())
                    reader.next();

                
                if (reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","type")!=null){
                  java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                        "type");
                  if (fullTypeName!=null){
                    java.lang.String nsPrefix = null;
                    if (fullTypeName.indexOf(":") > -1){
                        nsPrefix = fullTypeName.substring(0,fullTypeName.indexOf(":"));
                    }
                    nsPrefix = nsPrefix==null?"":nsPrefix;

                    java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(":")+1);
                    
                            if (!"Alarm".equals(type)){
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext().getNamespaceURI(nsPrefix);
                                return (Alarm)com.resourcedm.www.rdmplanttdb._2022._04._07.ExtensionMapper.getTypeObject(
                                     nsUri,type,reader);
                              }
                        

                  }
                

                }

                

                
                // Note all attributes that were handled. Used to differ normal attributes
                // from anyAttributes.
                java.util.Vector handledAttributes = new java.util.Vector();
                

                
                    
                    reader.next();
                   
                while(!reader.isEndElement()) {
                    if (reader.isStartElement() ){
                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/","Serial").equals(reader.getName())){
                                
                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setSerial(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                        else
                                    
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/","Text").equals(reader.getName())){
                                
                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setText(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                        else
                                    
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/","Occurred").equals(reader.getName())){
                                
                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setOccurred(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToDateTime(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                        else
                                    
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/","Accepted").equals(reader.getName())){
                                
                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setAccepted(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToDateTime(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                        else
                                    
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/","AcceptedBy").equals(reader.getName())){
                                
                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setAcceptedBy(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                        else
                                    
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2022/04/07/","Cleared").equals(reader.getName())){
                                
                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setCleared(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToDateTime(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                             else{
                                        // A start element we are not expecting indicates an invalid parameter was passed
                                        throw new org.apache.axis2.databinding.ADBException("Unexpected subelement " + reader.getName());
                             }
                          
                             } else {
                                reader.next();
                             }  
                           }  // end of while loop
                        



            } catch (javax.xml.stream.XMLStreamException e) {
                throw new java.lang.Exception(e);
            }

            return object;
        }

        }//end of factory class

        

        }
           
    