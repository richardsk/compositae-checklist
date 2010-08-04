Public Interface INameMatcher

    Property Id() As Integer
    Property FailId() As Integer
    Property SuccessId() As Integer

    Function GetMatchingNames(ByVal pn As ChecklistObjects.ProviderName) As DsNameMatch
    Sub RemoveNonMatches(ByVal pn As ChecklistObjects.ProviderName, ByRef names As DsNameMatch)
End Interface
