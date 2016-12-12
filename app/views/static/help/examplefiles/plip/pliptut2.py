# Read the PLIP result file and generates a list of binding site residue distances

from xml.dom.minidom import parseString
import xml.etree.ElementTree as ET

# Read in the PLIP result XML file as a tree
with open('report.xml','r') as f:
    data = f.read()
    root = ET.fromstring(data)

g = open('distances.data', 'w') # Open the output file for writing
for i, bindingsite in enumerate(root.findall('bindingsite')):
    # Find all data on binding site residue distances
    for bs_residue in bindingsite.iter('bs_residue'):
        dat = bs_residue.attrib
        d = dat['min_dist']
        g.write('value %s,id %s\n' % (d, i+1)) # Write all distances to the output file
