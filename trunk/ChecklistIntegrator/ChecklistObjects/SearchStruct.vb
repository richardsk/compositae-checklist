Imports System.Xml.Serialization
Imports System.IO
Imports System.Xml

', XmlRootAttribute(Namespace:="http://www.landcareresearch.co.nz/SearchStruct")
<Serializable()> _
Public Class SearchStruct
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/SearchText")> Public SearchText As String
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/Field")> Public Field As String
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/AnywhereInText")> Public AnywhereInText As Boolean
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/WholeWord")> Public WholeWord As Boolean
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/MisappliedOnly")> Public MisappliedOnly As Boolean
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/InEdOnly")> Public InEdOnly As Boolean
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/HybridOnly")> Public HybridOnly As Boolean
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/OrderField")> Public OrderField As String
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/OrderDirection")> Public OrderDirection As Boolean
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/CurrentNamesOnly")> Public CurrentNamesOnly As Boolean
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/DoNotShowSuppressed")> Public DoNotShowSuppressed As Boolean

    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/YearStart")> Public YearStart As Integer
    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/YearEnd")> Public YearEnd As Integer

    <XmlElement(Namespace:="http://www.landcareresearch.co.nz/CancelId")> Public CancelId As Guid

End Class
