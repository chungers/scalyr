from systemd import journal
from scalyr_agent import ScalyrMonitor


class JournaldMonitor(ScalyrMonitor):

    "Read logs from journalctl and emit to scalyr"

    def _initialize(self):
        self.__journal = journal.Reader(path="/var/log/journal")
        self.__journal.this_boot()
        self.__journal.seek_tail()
        self.log_config['parser'] = 'journald_monitor'

    def reset_journal(self, cursor):
        self.__journal = journal.Reader(path="/var/log/journal")
        self.__journal.this_boot()
        if cursor is None:
            self._logger.emit_value(
                'error', ('Trying to reset, but no prior cursor. '
                          'Something may be wrong'))
            self.seek_tail()
        else:
            self.__journal.seek_cursor(cursor)

    def read_from_journal(self):
        try:
            self.__journal.process()
        except Exception, e:
            self._logger.emit_value(
                'error', 'Failed to process', dict(error=str(e)))
        try:
            for entry in self.__journal:
                cursor = entry.get('__CURSOR')
                if cursor is None:
                    self.reset_journal(self._last_cursor)
                    return
                else:
                    self._last_cursor = cursor
                yield (msg, dict(
                    unit=str(entry.get('_SYSTEMD_UNIT', 'None')),
                    pid=str(entry.get('_PID', 'None')),
                    machine_id=str(entry.get('_MACHINE_ID', 'None')),
                    boot_id=str(entry.get('_BOOT_ID', 'None')),
                ))
        except Exception, e:
            self._logger.emit_value(
                'error', 'Failed to process', dict(error=str(e)))

    def gather_sample(self):
        for (message, fields) in self.read_from_journal():
            if message == "" or message == "{}":
                continue
            self._logger.emit_value('entry', message, extra_fields=fields)
