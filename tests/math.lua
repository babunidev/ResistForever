-- ResistForever pure-Lua regression checks.
-- Run from the repository root with: texlua tests/math.lua
-- A standard Lua interpreter can also run this file.

local source = debug.getinfo(1, "S").source
if source:sub(1, 1) == "@" then
    source = source:sub(2)
end

local root = source:match("^(.*[/\\])tests[/\\][^/\\]+$") or "./"

RESISTFOREVER_TESTING = true
local chunk, loadError = loadfile(root .. "ResistForever.lua")
assert(chunk, loadError)
local api = chunk()
RESISTFOREVER_TESTING = nil

assert(type(api) == "table", "production math test API was not returned")

local passed = 0

local function near(actual, expected, epsilon, label)
    epsilon = epsilon or 1e-10
    assert(math.abs(actual - expected) <= epsilon,
        string.format("%s: got %.12f, expected %.12f", label, actual, expected))
    passed = passed + 1
end

local function equal(actual, expected, label)
    assert(actual == expected,
        string.format("%s: got %s, expected %s", label, tostring(actual), tostring(expected)))
    passed = passed + 1
end

local function validateDistribution(resistance, level, label)
    local average = api.ComputeAverageResistance(resistance, level)
    local buckets = api.ComputePartialResistBuckets(resistance, level)
    assert(average and buckets, label .. ": distribution missing")

    local total = 0
    local weighted = 0
    for reduction = 0, 100, 10 do
        local chance = buckets[reduction] or 0
        assert(chance >= -1e-12 and chance <= 1 + 1e-12,
            string.format("%s: %d%% bucket out of range: %.12f", label, reduction, chance))
        total = total + chance
        weighted = weighted + (reduction / 100) * chance
    end

    near(total, 1, 1e-10, label .. " probability sum")
    near(weighted, average, 1e-10, label .. " weighted mean")
end

local a = api.ComputeAverageResistance(14, 19)
near(a, 14 / 185, 1e-12, "14 resistance at level 19 average")
local b = api.ComputePartialResistBuckets(14, 19)
near(b[0], 80 / 185, 1e-12, "14/19 0% bucket")
near(b[10], 70 / 185, 1e-12, "14/19 10% bucket")
near(b[20], 35 / 185, 1e-12, "14/19 20% bucket")

local middle = api.ComputePartialResistBuckets(90, 10)
near(middle[40], 0.25, 1e-12, "50% average 40% bucket")
near(middle[50], 0.50, 1e-12, "50% average 50% bucket")
near(middle[60], 0.25, 1e-12, "50% average 60% bucket")

local lowEdge = api.ComputePartialResistBuckets(10, 10)
near(lowEdge[0], 0.25, 1e-12, "10% average 0% bucket")
near(lowEdge[10], 0.50, 1e-12, "10% average 10% bucket")
near(lowEdge[20], 0.25, 1e-12, "10% average 20% bucket")

local highEdge = api.ComputePartialResistBuckets(810, 10)
near(highEdge[80], 0.25, 1e-12, "90% average 80% bucket")
near(highEdge[90], 0.50, 1e-12, "90% average 90% bucket")
near(highEdge[100], 0.25, 1e-12, "90% average 100% bucket")

for _, case in ipairs({
    { 14, 19, "low" },
    { 10, 10, "10% edge" },
    { 90, 10, "middle" },
    { 810, 10, "90% edge" },
    { 315, 60, "higher resistance" },
}) do
    validateDistribution(case[1], case[2], case[3])
end

near(api.ComputeSpellMiss(19, 19), 0.04, 1e-12, "same level miss")
near(api.ComputeSpellMiss(19, 20), 0.03, 1e-12, "+1 attacker miss")
near(api.ComputeSpellMiss(19, 22), 0.01, 1e-12, "+3 attacker miss")
near(api.ComputeSpellMiss(19, 23), 0.00, 1e-12, "+4 attacker zero floor")
near(api.ComputeSpellMiss(22, 19), 0.17, 1e-12, "+3 defender plateau")
near(api.ComputeSpellMiss(30, 19), 0.17, 1e-12, "large defender gap plateau")

equal(api.ComputeAverageResistance(0, 19), nil, "zero resistance average")
equal(api.ComputePartialResistBuckets(-1, 19), nil, "negative resistance buckets")

print(string.format("ResistForever math regression checks passed: %d assertions", passed))
