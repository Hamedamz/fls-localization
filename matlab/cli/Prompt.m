classdef Prompt < handle
    properties
        text
        default
        choices = []
        userChoice
    end
    
    methods
        function obj = Prompt(text, choices, default)
            obj.text = text;
            obj.choices = choices;
            obj.default = default;
        end

        function txt = getPrompt(obj)
            txt = sprintf("%s [%d]\n", obj.text, obj.default);

            for i= 1:size(obj.choices, 2)
                txt = strcat(txt, sprintf("%d. %s\n", i, obj.choices{i}));
            end
        end
        
        function out = getUserInput(obj)
            choice = input(obj.getPrompt(), "s");
            choice = str2num(choice);

            if isempty(choice)
                choice = obj.default;
            elseif choice < 1 || choice > size(obj.choices, 2)
                disp("invalid input");
                out = obj.getUserInput();
                return;
            end
            
            obj.userChoice = choice;
            out = choice;
        end
    end
end

