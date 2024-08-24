import java.util.HashSet;
import java.util.ArrayList;
import java.util.Random;
import java.util.Collections;

Grafo grafo;

void setup() {
  size(800, 600);
  frameRate(60);
  
  int n = 10;
  HashSet<PVector> arestas = new HashSet<>();
  
  // Gerar arestas aleatórias
  Random random = new Random();
  for (int i = 0; i < n; i++) {
    for (int j = i + 1; j < n; j++) {
      if (random.nextBoolean()) { // Aproximadamente 50% de chance de adicionar aresta
        int peso = random.nextInt(4) + 1; // Peso aleatório entre 1 e 4
        arestas.add(new PVector(i, j)); // Adiciona a aresta ao HashSet
      }
    }
  }
  
  grafo = new Grafo(n, arestas); // Passa o número de vértices e as arestas
}

void draw(){
  background(255);
  grafo.atualizar();
  grafo.desenhar(grafo.dijkstra(0, 8));
}
