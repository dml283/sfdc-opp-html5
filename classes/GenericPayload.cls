public with sharing class GenericPayload {

  public String label { get; private set; }
  public String content { get; set; }
  public String contentType { get; private set; }
  
  public GenericPayload (String label, String content, String contentType) {    
    this.label = label; 
    this.content = content;
    this.contentType = contentType;  
  }  
  
}