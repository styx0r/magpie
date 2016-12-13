import os

class ConfigFile:
    def __init__(self, cfile):
        self.file = cfile
        self.params = {}
        self.parse_config()

    def parse_config(self):
        """Parse config file"""
        with open(self.file, 'r') as f:
            for line in [l for l in f.readlines() if not (l.startswith('#') or len(l.strip())==0)]:
                param, value = line.strip().split(' ')
                if value == 'true':
                    self.params[param] = True
                elif value == 'false':
                    self.params[param] = False
                else:
                    self.params[param] = str(value)


### Read in config

default = ConfigFile('default.config')
thresholds = ConfigFile('thresholds.config')


if default.params['input'] == 'pdbid':
    inputparam = '-i %s' % default.params['pdbid']
elif default.params['input'] == 'pdbfile':
    inputparam = '-f %s' % default.params['pdbfile']

vals = (inputparam, thresholds.params['hydroph_dist_max'], thresholds.params['hbond_dist_max'], thresholds.params['hbond_don_angle_min'], thresholds.params['aromatic_planarity'], thresholds.params['pistack_ang_dev'], thresholds.params['pication_dist_max'], thresholds.params['halogen_dist_max'], thresholds.params['halogen_don_angle'], thresholds.params['water_bridge_mindist'], thresholds.params['water_bridge_omega_min'], thresholds.params['water_bridge_theta_min'], '-v' if default.params['verbose'] else '', '--breakcomposite' if default.params['breakcomposite'] else '', '--altlocation' if default.params['altlocation'] else '', '--nofix' if default.params['nofix'] else '', '--keepmod' if default.params['keepmod'] else '')
os.system("plip/plipcmd %s -xtyp --hydroph_dist_max %s --hbond_dist_max %s --hbond_don_angle_min %s --aromatic_planarity %s --pistack_ang_dev %s --pication_dist_max %s --halogen_dist_max %s --halogen_don_angle %s --water_bridge_mindist %s --water_bridge_omega_min %s --water_bridge_theta_min %s %s %s %s %s %s" % vals)

