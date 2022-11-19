#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Teleserv is a small python3 server using websocket to serve VDT / VTX content to
Minitels using a websocket.
"""

import argparse
import logging
import sys
import colorsys

class Teleserv:
    """
    The Minitel server.
    """

    def __init__(self, listenAddress="0.0.0.0", listenPort=3615):
        """
        Init the server.

        :param listenAddress: Listening address for the server.
        :param listenPort: Listening port for the server.
        """

        self.listenAddress = listenAddress
        self.listenPort = listenPort


def get_params():
    """
    Read parameters
    """
    parser = argparse.ArgumentParser(description='Python3 server using websockets'
                                     'to serve VDT / VTX content to a Minitel.')

    parser.add_argument('-a', '--listen_addr',
                        default='0.0.0.0',
                        dest='listen_addr',
                        help='Address to use to listen incoming connections. '
                             'Default: 0.0.0.0')

    parser.add_argument('-p', '--listen_port',
                        default='3615',
                        dest='listen_port',
                        type=int,
                        help='Port the server will use to listen to connections '
                             'Default: 3615')

    return parser.parse_args()


def main():
    """
    Push a vdt file to any client Minitel
    """
    logging.basicConfig(
        format='%(levelname)s:%(message)s', level=logging.DEBUG
    )
    params = get_params()
    server = Teleserv(params.listen_addr, params.listen_port)

    print("Hello world!")


if __name__ == '__main__':
    sys.exit(main())
