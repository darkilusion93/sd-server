

AddEventHandler('ragdollRequestEvent', function(sender, ev)
    CancelEvent()
end)

AddEventHandler('clearPedTasksEvent', function(source)
    CancelEvent()
end)