from xml.dom.minidom import parseString
import xml.etree.ElementTree as ET

with open('report.xml','r') as f:
    data = f.read()
    root = ET.fromstring(data)

g = open('distances.data', 'w')
for i, bindingsite in enumerate(root.findall('bindingsite')):
    for bs_residue in bindingsite.iter('bs_residue'):
        dat = bs_residue.attrib
        d = dat['min_dist']
        g.write('value %s,id %s\n' % (d, i+1))
