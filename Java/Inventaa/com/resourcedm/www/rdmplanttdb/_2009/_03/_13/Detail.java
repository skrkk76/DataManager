
/**
 * Detail.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.1  Built on : Aug 31, 2011 (12:23:23 CEST)
 */

            
                package com.resourcedm.www.rdmplanttdb._2009._03._13;
            

            /**
            *  Detail bean class
            */
            @SuppressWarnings({"unchecked","unused"})
        
        public  class Detail
        implements org.apache.axis2.databinding.ADBBean{
        /* This type was generated from the piece of schema that had
                name = Detail
                Namespace URI = http://www.resourcedm.com/RDMPlantTDB/2009/03/13/
                Namespace Prefix = ns1
                */
            

                        /**
                        * field for Type
                        */

                        
                                    protected com.resourcedm.www.rdmplanttdb._2009._03._13.ItemType localType ;
                                

                           /**
                           * Auto generated getter method
                           * @return com.resourcedm.www.rdmplanttdb._2009._03._13.ItemType
                           */
                           public  com.resourcedm.www.rdmplanttdb._2009._03._13.ItemType getType(){
                               return localType;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Type
                               */
                               public void setType(com.resourcedm.www.rdmplanttdb._2009._03._13.ItemType param){
                            
                                            this.localType=param;
                                    

                               }
                            

                        /**
                        * field for Min
                        */

                        
                                    protected java.lang.String localMin ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localMinTracker = false ;

                           public boolean isMinSpecified(){
                               return localMinTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getMin(){
                               return localMin;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Min
                               */
                               public void setMin(java.lang.String param){
                            localMinTracker = param != null;
                                   
                                            this.localMin=param;
                                    

                               }
                            

                        /**
                        * field for Max
                        */

                        
                                    protected java.lang.String localMax ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localMaxTracker = false ;

                           public boolean isMaxSpecified(){
                               return localMaxTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getMax(){
                               return localMax;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Max
                               */
                               public void setMax(java.lang.String param){
                            localMaxTracker = param != null;
                                   
                                            this.localMax=param;
                                    

                               }
                            

                        /**
                        * field for Step
                        */

                        
                                    protected java.lang.String localStep ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localStepTracker = false ;

                           public boolean isStepSpecified(){
                               return localStepTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getStep(){
                               return localStep;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Step
                               */
                               public void setStep(java.lang.String param){
                            localStepTracker = param != null;
                                   
                                            this.localStep=param;
                                    

                               }
                            

                        /**
                        * field for Strings
                        */

                        
                                    protected com.resourcedm.www.rdmplanttdb._2009._03._13.ArrayOfStrings localStrings ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localStringsTracker = false ;

                           public boolean isStringsSpecified(){
                               return localStringsTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return com.resourcedm.www.rdmplanttdb._2009._03._13.ArrayOfStrings
                           */
                           public  com.resourcedm.www.rdmplanttdb._2009._03._13.ArrayOfStrings getStrings(){
                               return localStrings;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Strings
                               */
                               public void setStrings(com.resourcedm.www.rdmplanttdb._2009._03._13.ArrayOfStrings param){
                            localStringsTracker = param != null;
                                   
                                            this.localStrings=param;
                                    

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
               

                   java.lang.String namespacePrefix = registerPrefix(xmlWriter,"http://www.resourcedm.com/RDMPlantTDB/2009/03/13/");
                   if ((namespacePrefix != null) && (namespacePrefix.trim().length() > 0)){
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           namespacePrefix+":Detail",
                           xmlWriter);
                   } else {
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           "Detail",
                           xmlWriter);
                   }

               
                   }
               
                                            if (localType==null){
                                                 throw new org.apache.axis2.databinding.ADBException("Type cannot be null!!");
                                            }
                                           localType.serialize(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/","Type"),
                                               xmlWriter);
                                         if (localMinTracker){
                                    namespace = "http://www.resourcedm.com/RDMPlantTDB/2009/03/13/";
                                    writeStartElement(null, namespace, "Min", xmlWriter);
                             

                                          if (localMin==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("Min cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localMin);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localMaxTracker){
                                    namespace = "http://www.resourcedm.com/RDMPlantTDB/2009/03/13/";
                                    writeStartElement(null, namespace, "Max", xmlWriter);
                             

                                          if (localMax==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("Max cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localMax);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localStepTracker){
                                    namespace = "http://www.resourcedm.com/RDMPlantTDB/2009/03/13/";
                                    writeStartElement(null, namespace, "Step", xmlWriter);
                             

                                          if (localStep==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("Step cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localStep);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localStringsTracker){
                                            if (localStrings==null){
                                                 throw new org.apache.axis2.databinding.ADBException("Strings cannot be null!!");
                                            }
                                           localStrings.serialize(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/","Strings"),
                                               xmlWriter);
                                        }
                    xmlWriter.writeEndElement();
               

        }

        private static java.lang.String generatePrefix(java.lang.String namespace) {
            if(namespace.equals("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/")){
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

                
                            elementList.add(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                                      "Type"));
                            
                            
                                    if (localType==null){
                                         throw new org.apache.axis2.databinding.ADBException("Type cannot be null!!");
                                    }
                                    elementList.add(localType);
                                 if (localMinTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                                      "Min"));
                                 
                                        if (localMin != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localMin));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("Min cannot be null!!");
                                        }
                                    } if (localMaxTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                                      "Max"));
                                 
                                        if (localMax != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localMax));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("Max cannot be null!!");
                                        }
                                    } if (localStepTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                                      "Step"));
                                 
                                        if (localStep != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localStep));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("Step cannot be null!!");
                                        }
                                    } if (localStringsTracker){
                            elementList.add(new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/",
                                                                      "Strings"));
                            
                            
                                    if (localStrings==null){
                                         throw new org.apache.axis2.databinding.ADBException("Strings cannot be null!!");
                                    }
                                    elementList.add(localStrings);
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
        public static Detail parse(javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{
            Detail object =
                new Detail();

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
                    
                            if (!"Detail".equals(type)){
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext().getNamespaceURI(nsPrefix);
                                return (Detail)com.resourcedm.www.rdmplanttdb._2009._03._13.ExtensionMapper.getTypeObject(
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
                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/","Type").equals(reader.getName())){
                                
                                                object.setType(com.resourcedm.www.rdmplanttdb._2009._03._13.ItemType.Factory.parse(reader));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                        else
                                    
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/","Min").equals(reader.getName())){
                                
                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setMin(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                        else
                                    
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/","Max").equals(reader.getName())){
                                
                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setMax(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                        else
                                    
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/","Step").equals(reader.getName())){
                                
                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setStep(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                        else
                                    
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://www.resourcedm.com/RDMPlantTDB/2009/03/13/","Strings").equals(reader.getName())){
                                
                                                object.setStrings(com.resourcedm.www.rdmplanttdb._2009._03._13.ArrayOfStrings.Factory.parse(reader));
                                              
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
           
    