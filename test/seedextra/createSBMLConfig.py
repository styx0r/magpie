from libsbml import *
import sys
import os

if len(sys.argv) < 2:
    print 'Need the sbml model as input parameter.'
    sys.exit()

if not os.path.isfile(sys.argv[1]):
    print 'Is not a valid path to a sbml file.'
    sys.exit()

reader = SBMLReader()

document = reader.readSBML(sys.argv[1])
document.getNumErrors()

model = document.getModel()
parameters = model.parameters
species = model.species
compartments = model.compartments
events = model.events
reactions = model.reactions

# write out the list of parameter in parameter.config
if len(parameters) != 0:
    f = open("parameter.config", "w")
    for e in parameters:
        f.write(e.getId() + " double " + str(e.getValue()) + "\n")
    f.close()

# write out compartment configuration into compartment.config
if len(compartments) != 0:
    f = open("compartment.config", "w")
    for e in compartments:
        f.write("# " + e.getName() + "\n")
        f.write(e.getId() + "_spatial_dimensions" + " double " + str(e.getSpatialDimensions()) + "\n")
        f.write(e.getId() + "_size" + " double " + str(e.getSize()) + "\n")
    f.close()

# write out species configuration into species.config
# check for default: initial_amount vs. initial_concentration (in case both is 0)
species_initial_amount = 0
species_initial_concentration = 0
if len(species) != 0:
    for e in species:
        if e.getInitialAmount() > 0:
            species_initial_amount += 1
        if e.getInitialConcentration() > 0:
            species_initial_concentration += 1
if len(species) != 0:
    f = open("species.config", "w")
    for e in species:
        if e.getInitialAmount() > 0:
            f.write("# " + e.getName() + "\n")
            f.write(e.id + "_initial_amount double " + str(e.getInitialAmount()) + "\n")
        elif e.getInitialConcentration() > 0:
            f.write("# " + e.getName() + "\n")
            f.write(e.id + "_initial_concentration double " + str(e.getInitialConcentration()) + "\n")
        else:
            if species_initial_amount > species_initial_concentration:
                f.write("# " + e.getName() + "\n")
                f.write(e.id + "_initial_amount double 0\n")
            else:
                f.write("# " + e.getName() + "\n")
                f.write(e.id + "_initial_concentration double 0\n")
    f.close()

f = open("solver.config", "w")
f.write("# simulation time\n")
f.write("t double 100\n")
f.write("# simulation steps\n")
f.write("s double 100\n")
f.write("# numerical integration algorithm\n")
f.write("m dropdown Runge-Kutta Runge-Kutta AM1_and_BD1_implicit_euler AM2_Crank_Nicolson AM3 AM4 BD2 BD3 BD4 AB1_explicit_euler AB2 AB3 AB4 Runge-Kutta-Fehlberg Cash-Karp\n")
f.close()
