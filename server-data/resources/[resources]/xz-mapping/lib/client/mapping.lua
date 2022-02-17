XZ.Mapping = {};
XZ.Mapping.Handlers = {};
XZ.Mapping.Structure = "%s__XZ_%s";

function XZ.Mapping:Emit(cmd, state)
    for _, event in next, self.Handlers[cmd] do
        event(state);
    end
end

function XZ.Mapping:Listen(cmd, label, type, key, event)
    if not self.Handlers[cmd] then
        self.Handlers[cmd] = {};

        RegisterCommand(self.Structure:format("+", cmd), function()
            self:Emit(cmd, true);
        end, false);

        RegisterCommand(self.Structure:format("-", cmd), function()
            self:Emit(cmd, false);
        end, false);

        RegisterKeyMapping(self.Structure:format("+", cmd), label, type, key);
    end

    self.Handlers[cmd][#self.Handlers[cmd]+1] = event;
end

exports("EmitKeyMapping", _M(XZ.Mapping, XZ.Mapping.Emit));
exports("ListenKeyMapping", _M(XZ.Mapping, XZ.Mapping.Listen));