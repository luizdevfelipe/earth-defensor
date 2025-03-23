function love.update(dt)
  sombraRot = sombraRot + 1 * dt
  x, y = orbita(centroJanelaX, centroJanelaY, 250, sombraRot)
  
  lua.posX = x
  lua.posY = y

end

function orbita(centroX, centroY, raio, angulo)
    local x = centroX + math.cos(angulo) * raio
    local y = centroY + math.sin(angulo) * raio
    return x, y
end