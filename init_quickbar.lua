--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 17/02/2017
-- Time: 11:46
-- To change this template use File | Settings | File Templates.
--

function Clockwork.updateActionButtons()
    Clockwork.rotationsActions[Clockwork.player.specialization.id]()
end
