#!/usr/bin/python
# check_load_relative_2.py
# Author: Imran Ahmed <researcher6@live.com>
# Description : This script checks the relative load for a multi core cpu system. It can also log the performance data.

import nagiosplugin, argparse

class Load(nagiosplugin.Resource):
	

# This check uses /proc files and assumes Ubuntu is the host Linux distro as it  uses nproc command.
 

    def __init__(self, relative=True):
        self.relative = relative

    def noCpus(self):
        _log.info('Number of cpus using "nproc"')
        cpus = int(subprocess.check_output(['nproc']))
        _log.debug('found %i cpus in total', cpus)
        return cpus

    def probe(self):
        _log.info('Calculate load from /proc/loadavg')
        with open('/proc/loadavg') as loadavg:
            load = loadavg.readline().split()[0:3]
        _log.debug('ABSOLUTE load is %s', load)
        cpus = int(self.noCpus())
        load = [float(maxLoad) / cpus for maxLoad in load]
        for i, period in enumerate([1, 5, 15]):
            yield nagiosplugin.Metric('load%d' % period, load[i], min=0,
                                      context='load')


def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument('-w', '--warning', metavar='RANGE', default='',
                      help='say WARNING if threshold is crossed')
    argp.add_argument('-c', '--critical', metavar='RANGE', default='',
                      help='say CRITICAL if threshold is crossed')
    argp.add_argument('-r', '--relative', action='store_true', default=True)
    args = argp.parse_args()
    check = nagiosplugin.Check(
        Load(args.relative),
        nagiosplugin.ScalarContext('load', args.warning, args.critical))
    check.main()

if __name__ == '__main__':
    main()
