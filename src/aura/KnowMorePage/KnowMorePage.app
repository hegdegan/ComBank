<aura:application implements="force:hasRecordId" extends="force:slds">
    <aura:attribute name="recordId" type="Id"/>
    
        <c:KnowMore recordId="{!v.recordId}"/>
        
</aura:application>