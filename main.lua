local start = os.clock()
ngoto = 0
::label::
local function dummy(i) i = i + i  end
local function f(i) i = i * i * i ; end
local start = os.clock()
local n=99990900
for i=1,n do dummy(i) end -- loop/call overhead
for i=1,n do f(i) end
if ngoto == 0 then
ngoto = 1
print('goto')
goto label

end
print(os.clock() - start)
