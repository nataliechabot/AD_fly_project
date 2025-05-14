#!/usr/bin/env python3
#creating graph networks for social network analysis of one focal and three scarlet flies.


import pandas as pd
import numpy as np
import networkx as nx
from scipy.spatial.distance import pdist, squareform
import matplotlib.pyplot as plt
from tqdm import tqdm
import matplotlib
matplotlib.use('TkAgg')


df = pd.read_csv("session_2F_2/trajectories/validated_csv/trajectories.csv")

# Rename original x/y columns
df = df.rename(columns={
    'x1': 'fly1_x', 'y1': 'fly1_y',
    'x2': 'fly2_x', 'y2': 'fly2_y',
    'x3': 'fly3_x', 'y3': 'fly3_y',
    'x4': 'fly4_x', 'y4': 'fly4_y'
})

df['frame'] = df.index


# setting up my focal fly

FOCAL_X = 'x4'  # <-- change this to your focal fly's x column (e.g., 'x2')
FOCAL_Y = 'y4'  # <-- change this to your focal fly's y column (e.g., 'y2')

# Derive fly ID from FOCAL_X (e.g., 'fly3')
focal_key = 'fly' + ''.join(filter(str.isdigit, FOCAL_X))


# Melt and tidy data

melted = df.melt(id_vars='frame', var_name='fly_coord', value_name='position')
melted[['fly_id', 'axis']] = melted['fly_coord'].str.extract(r'(fly\d)_(x|y)')
tidy_df = melted.pivot_table(index=['frame', 'fly_id'], columns='axis', values='position').reset_index()
tidy_df.dropna(subset=['x', 'y'], inplace=True)


# Rename fly IDs: focal = 'F'. Others call = '1', '2', '3'

unique_flies = tidy_df['fly_id'].unique()
fly_labels = {focal_key: 'F'}

non_focal_flies = [fly for fly in unique_flies if fly != focal_key]
np.random.seed(42)
random_labels = ['1', '2', '3']
np.random.shuffle(random_labels)
fly_labels.update(dict(zip(non_focal_flies, random_labels)))

tidy_df['fly_id'] = tidy_df['fly_id'].map(fly_labels)
tidy_df.dropna(subset=['fly_id'], inplace=True)  
# Prevent NaN fly nodes

print("Fly label mapping:", fly_labels)


# Build interaction network

PROXIMITY_THRESHOLD = 139
interaction_counts = {}
frames = tidy_df['frame'].unique()

for frame in tqdm(frames[1:], desc="Processing frames"):
    frame_data = tidy_df[tidy_df['frame'] == frame]
    prev_data = tidy_df[tidy_df['frame'] == frame - 1]

    ids = frame_data['fly_id'].values
    positions = frame_data[['x', 'y']].values

    if len(ids) < 2 or prev_data.empty:
        continue

    dists = squareform(pdist(positions))

    for i in range(len(ids)):
        for j in range(i + 1, len(ids)):
            if dists[i, j] < PROXIMITY_THRESHOLD:
                fly_i_prev = prev_data[prev_data['fly_id'] == ids[i]][['x', 'y']].values
                fly_j_prev = prev_data[prev_data['fly_id'] == ids[j]][['x', 'y']].values

                if fly_i_prev.size and fly_j_prev.size:
                    pair = tuple(sorted((ids[i], ids[j])))
                    interaction_counts[pair] = interaction_counts.get(pair, 0) + 1

# Build the graph!!!
G = nx.Graph()
G.add_nodes_from(tidy_df['fly_id'].unique())
for (fly1, fly2), count in interaction_counts.items():
    G.add_edge(fly1, fly2, weight=count)


# Network metrics

strength = dict(G.degree(weight='weight'))
clustering = nx.clustering(G, weight='weight')
density = nx.density(G)

print("\nNetwork Metrics:")
print("Strength:", strength)
print("Clustering:", clustering)
print("Density:", density)


# Layout

plt.figure(figsize=(6, 6))
pos = nx.spring_layout(G, seed=42, k=2.5)
#pos = nx.circular_layout(G)
#pos = nx.kamada_kawai_layout(G)
#pos = nx.spectral_layout(G)  


node_sizes = [strength.get(node, 1) * 1 for node in G.nodes]
labels = {node: f"{node}\n({strength.get(node, 0)})" for node in G.nodes}

# Draw nodes: highlight focal fly!
node_colors = ['red' if node == 'F' else 'lightgreen' for node in G.nodes]
nx.draw_networkx_nodes(G, pos, node_size=node_sizes, node_color=node_colors)

edges = G.edges(data=True)
weights = [data['weight'] for _, _, data in edges]
nx.draw_networkx_edges(G, pos, edgelist=edges, width=[w / 500 for w in weights])

# Edge labels
edge_labels = nx.get_edge_attributes(G, 'weight')
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=12)

# Node labels
nx.draw_networkx_labels(G, pos, labels=labels, font_size=13, font_weight='bold')

plt.title("Undirected Fly Interaction Network", fontsize=16)
plt.axis('off')
plt.tight_layout()
plt.show()
