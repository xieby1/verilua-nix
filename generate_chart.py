#!/usr/bin/env python3
"""Generate an interactive Plotly chart of closure_size over time from dolt quality CSV."""

import csv
import sys
from datetime import datetime

import plotly.graph_objects as go

REPO_URL = "https://github.com/xieby1/verilua-nix"
MAX_POINTS = 30


def main():
    csv_path = sys.argv[1] if len(sys.argv) > 1 else "quality.csv"

    rows = []
    with open(csv_path) as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows.append(row)

    # Sort by date ascending, keep last MAX_POINTS
    rows.sort(key=lambda r: int(r["date"]))
    rows = rows[-MAX_POINTS:]

    date_labels = []
    sizes_mb = []
    urls = []

    for row in rows:
        dt = datetime.fromtimestamp(int(row["date"]))
        size_mb = int(row["closure_size"]) / (1024 * 1024)
        commit = row["commit_hash"]

        date_labels.append(dt.strftime("%Y-%m-%d"))
        sizes_mb.append(round(size_mb, 2))
        urls.append(f"{REPO_URL}/commit/{commit}")

    # Use integer indices for uniform spacing, dates as tick labels
    x_indices = list(range(len(rows)))

    fig = go.Figure()
    fig.add_trace(go.Scatter(
        x=x_indices,
        y=sizes_mb,
        mode="lines+markers",
        marker=dict(size=8),
        customdata=list(zip(urls, date_labels)),
        hovertemplate=(
            "%{customdata[0]}<br>"
            "Date: %{customdata[1]}<br>"
            "Closure size: %{y:.2f} MB<br>"
            "<extra></extra>"
        ),
    ))

    fig.update_layout(
        title="verilua-nix Closure Size Over Time",
        xaxis=dict(
            title="Date",
            tickmode="array",
            tickvals=x_indices,
            ticktext=date_labels,
        ),
        yaxis_title="Closure Size (MB)",
        hovermode="closest",
        template="plotly_white",
    )

    # JavaScript to open commit URL on click
    click_js = """
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var plot = document.querySelector('.plotly-graph-div');
        if (plot) {
            plot.on('plotly_click', function(data) {
                var url = data.points[0].customdata[0];
                if (url) window.open(url, '_blank');
            });
        }
    });
    </script>
    """

    html = fig.to_html(full_html=True, include_plotlyjs=True)
    html = html.replace("</body>", click_js + "</body>")

    with open("index.html", "w") as f:
        f.write(html)

    print(f"Generated index.html with {len(rows)} data points")


if __name__ == "__main__":
    main()
