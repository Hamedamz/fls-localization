function dispatcher = selectDispatcher(point, dispatchers)
    if size(point, 1) == 2
        dispatcher = dispatchers{1};
    else
        dispatcher = dispatchers{2};
    end

end

