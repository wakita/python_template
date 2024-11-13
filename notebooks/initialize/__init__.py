import sys
from pathlib import Path

PROJECT = Path(__file__).parent.parent.parent
if str(PROJECT / 'src') not in sys.path:
    sys.path.append(str(PROJECT / 'src'))
