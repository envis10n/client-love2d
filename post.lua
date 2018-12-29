local moonshine = require 'moonshine'
local effect = nil
function load()
    if(not cfg.effects.glow and not cfg.effects.scanlines and not cfg.effects.crt and not cfg.effects.filmgrain) then
        effect = function(func)
            func()
        end
    else
        effect = nil
        if(cfg.effects.glow) then
            if (effect == nil) then
                effect = moonshine(moonshine.effects.glow)
            else
                effect = effect.chain(moonshine.effects.glow)
            end
            effect.glow.strength = 0.5
            effect.glow.min_luma = 0
        end
        if(cfg.effects.scanlines) then
            if (effect == nil) then
                effect = moonshine(moonshine.effects.scanlines)
            else
                effect = effect.chain(moonshine.effects.scanlines)
            end
            effect.scanlines.thickness = 0.3
        end
        if(cfg.effects.filmgrain) then
            if (effect == nil) then
                effect = moonshine(moonshine.effects.filmgrain)
            else
                effect = effect.chain(moonshine.effects.filmgrain)
            end
        end
        if(cfg.effects.crt) then
            if (effect == nil) then
                effect = moonshine(moonshine.effects.crt)
            else
                effect = effect.chain(moonshine.effects.crt)
            end
            effect.crt.distortionFactor = {1.02, 1.026}
            effect.crt.feather = 0.04
        end
    end
    return effect
end

return load