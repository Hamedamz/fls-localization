classdef FLSSwarm < handle
    properties
        members = []
        enabled = 0
        swarmPolicy
    end

    methods
        function obj = FLSSwarm(enabled, swarmPolicy)
            obj.enabled = enabled;
            obj.swarmPolicy = swarmPolicy;
        end

        function follow(obj, self, v)
            if obj.enabled
                if obj.swarmPolicy == 2
                    self.locked = 1;
                end

                M = obj.getAllMembers([]);
                n = size(M, 2);
                count = 0;
                
                for i = 1:n
                    fls = M(i);
                    if fls.id == self.id
                        continue;
                    end
                    
                    if obj.swarmPolicy == 2
                        if ~fls.locked
                            fls.swarm.enabled = 0;
                            fls.flyTo(fls.el + v);
                            fls.swarm.enabled = 1;
                            fls.locked = 1;
                        end
                    else
                        fls.swarm.enabled = 0;
                        fls.flyTo(fls.el + v);
                        fls.d3 = fls.d3 + norm(v);
                        fls.swarm.enabled = 1;
                    end
                    count = count + 1;
                end

                if count
                    fprintf('  FLS %s caused %d FLS(s) to move in its swarm\n', self.id, count);
%                     disp([M.id]);
                end
            end
        end

        function addMember(obj, fls)
            if obj.enabled
                for i = 1:size(obj.members, 2)
                    m = obj.members(i);
                    if fls.id == m.id
                        return;
                    end
                end
                obj.members = [obj.members fls];
            end
        end
        
        function removeMember(obj, fls)
            found = 0;
            for i = 1:size(obj.members, 2)
                m = obj.members(i);
                if fls.id == m.id
                    found = 1;
                    break;
                end
            end

            if found
                obj.members(i) = [];
            end
        end

        function M = getAllMembers(obj, m)
            for i = 1:size(obj.members, 2)
                fls = obj.members(i);
                skip = 0;
                for j = 1:size(m, 2)
                    if m(j).id == fls.id
                        skip = 1;
                        break;
                    end
                end
                if skip
                    continue;
                end
                m = [m fls];
                m = fls.swarm.getAllMembers(m);
            end
            M = m;
        end
    end
end
