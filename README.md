A simple, yet powerful global state library for **flutter** projects.

Uses **MapStream**s from [package:map_stream] to hold state, which
automatically pushes updates as streams

**StreamingState** extends **StatefulWidget**'s **State** class, allowing
a **MapStream** to attach. Whenever an update from the stream arrives the
**Widget** rerenders.

**MapStreamBuilder**, similar to **StreamBuilder**, is a Widget that builds
itself based on the current **MapStream** state.

See documentation for more information.
