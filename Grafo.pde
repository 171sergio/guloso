import java.util.HashSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;

class Grafo {
  int numVertices;
  HashSet<PVector> arestas; // Usa HashSet<PVector> para armazenar arestas
  PVector[] posicoes; // Posições das partículas (nós do grafo)
  PVector[] velocidades; // Velocidades das partículas
  float raio = 10; // Raio dos nós
  float k = 0.001; // Constante da mola para a atração
  float c = 3000; // Constante de repulsão
  
  // Adiciona um array para armazenar as cores dos vértices
  int[] cores;

  // Construtor da classe Grafo com HashSet de arestas
  Grafo(int numVertices, HashSet<PVector> arestas) {
    this.numVertices = numVertices;
    this.arestas = arestas;
    posicoes = new PVector[numVertices];
    velocidades = new PVector[numVertices];
    cores = new int[numVertices]; // Inicializa o array de cores
    inicializarPosicoes();
    colorirGrafo(); // Colore o grafo após inicializar as posições
  }

  // Inicializa as posições das partículas em um círculo
  void inicializarPosicoes() {
    float angulo = TWO_PI / numVertices;
    float raioCirculo = min(width, height) / 3;
    for (int i = 0; i < numVertices; i++) {
      float x = width / 2 + raioCirculo * cos(i * angulo);
      float y = height / 2 + raioCirculo * sin(i * angulo);
      posicoes[i] = new PVector(x, y);
      velocidades[i] = new PVector(0, 0);
    }
  }

  // Método para gerar uma cor aleatória não usada
  // Método para gerar uma cor aleatória não usada
int gerarCorAleatoria(HashSet<Integer> coresUsadas) {
    Random random = new Random();
    int cor;
    do {
        int cor1 = random.nextInt(256); // Valor de 0 a 255 para o componente vermelho
        int cor2 = random.nextInt(256); // Valor de 0 a 255 para o componente verde
        int cor3 = random.nextInt(256); // Valor de 0 a 255 para o componente azul
        cor = color(cor1, cor2, cor3);
    } while (coresUsadas.contains(cor));
    return cor;
}


  // Método para colorir o grafo
void colorirGrafo() {
    // Cria um HashSet para manter controle das cores usadas
    HashSet<Integer> coresUsadas = new HashSet<>();
    
    // Array para armazenar as cores dos vértices
    int[] cores = new int[numVertices];
    
    // Itera sobre todos os vértices
    for (int v = 0; v < numVertices; v++) {
        // Cria um HashSet para armazenar as cores dos vizinhos
        HashSet<Integer> coresVizinhos = new HashSet<>();
        
        // Encontra as cores dos vizinhos do vértice atual
        for (PVector aresta : arestas) {
            int v1 = (int) aresta.x;
            int v2 = (int) aresta.y;
            if (v1 == v && cores[v2] != 0) {
                coresVizinhos.add(cores[v2]);
            } else if (v2 == v && cores[v1] != 0) {
                coresVizinhos.add(cores[v1]);
            }
        }
        
        // Atribui a menor cor disponível que não esteja em uso pelos vizinhos
        int cor = 1;
        while (coresVizinhos.contains(cor)) {
            cor++;
        }
        cores[v] = cor;
        coresUsadas.add(cor);
    }
    
    // Atualiza o array de cores da classe Grafo
    this.cores = cores;
}


  // Atualiza as posições das partículas
  void atualizar() {
    for (int i = 0; i < numVertices; i++) {
      PVector forca = new PVector(0, 0);
      
      // Força de repulsão
      for (int j = 0; j < numVertices; j++) {
        if (i != j) {
          PVector direcao = PVector.sub(posicoes[i], posicoes[j]);
          float distancia = direcao.mag();
          if (distancia > 0) {
            direcao.normalize();
            float forcaRepulsao = c / (distancia * distancia);
            direcao.mult(forcaRepulsao);
            forca.add(direcao);
          }
        }
      }

      // Força de atração
      for (PVector aresta : arestas) {
        int v1 = (int) aresta.x;
        int v2 = (int) aresta.y;
        if (v1 == i || v2 == i) {
          int outroVertice = (v1 == i) ? v2 : v1;
          PVector direcao = PVector.sub(posicoes[outroVertice], posicoes[i]);
          float distancia = direcao.mag();
          direcao.normalize();
          float forcaAtracao = k * (distancia - raio);
          direcao.mult(forcaAtracao);
          forca.add(direcao);
        }
      }

      velocidades[i].add(forca);
      posicoes[i].add(velocidades[i]);

      // Reduz a velocidade para estabilizar a simulação
      velocidades[i].mult(0.05); // Ajuste o fator para diminuir a velocidade

      // Mantém as partículas dentro da tela
      if (posicoes[i].x < 0) {
        posicoes[i].x = 0;
        velocidades[i].x *= -1;
      }
      if (posicoes[i].x > width) {
        posicoes[i].x = width;
        velocidades[i].x *= -1;
      }
      if (posicoes[i].y < 0) {
        posicoes[i].y = 0;
        velocidades[i].y *= -1;
      }
      if (posicoes[i].y > height) {
        posicoes[i].y = height;
        velocidades[i].y *= -1;
      }
    }
  }
int bah = (int)random(500);
  // Desenha o grafo
  void desenhar(ArrayList<Integer> caminho) {
    background(255); // Limpa o fundo a cada frame

    // Desenha as arestas
    stroke(0); // Cor das arestas
    strokeWeight(1); // Espessura das arestas
    for (PVector aresta : arestas) {
      int v1 = (int) aresta.x;
      int v2 = (int) aresta.y;
      line(posicoes[v1].x, posicoes[v1].y, posicoes[v2].x, posicoes[v2].y);
    }

    // Desenha as arestas do menor caminho em vermelho
    stroke(255, 0, 0); // Cor das arestas do caminho
    strokeWeight(2); // Aumenta a espessura das arestas do caminho
    for (int i = 0; i < caminho.size() - 1; i++) {
      int atual = caminho.get(i);
      int proximo = caminho.get(i + 1);
      line(posicoes[atual].x, posicoes[atual].y, posicoes[proximo].x, posicoes[proximo].y);
    }

    // Desenha os nós
    for (int i = 0; i < numVertices; i++) {
      // Define a cor do nó com base na cor atribuída
      int cor = cores[i];
      color c = color(cor * 100, 150, bah); // Ajuste a cor conforme necessário
      fill(c);
      stroke(0); // Cor da borda dos nós
      strokeWeight(1); // Espessura da borda dos nós
      ellipse(posicoes[i].x, posicoes[i].y, raio * 2, raio * 2);
      
      // Desenha o número do vértice
      fill(0); // Cor do texto
      textAlign(CENTER, CENTER); // Alinhamento do texto
      textSize(12); // Tamanho do texto
      text(str(i), posicoes[i].x, posicoes[i].y); // Texto no centro do círculo
    }
  }

  // Implementação do algoritmo de Dijkstra para encontrar o menor caminho
  ArrayList<Integer> dijkstra(int origem, int destino) {
    int[] dist = new int[numVertices];
    int[] anterior = new int[numVertices];
    for (int v = 0; v < numVertices; v++) {
      dist[v] = Integer.MAX_VALUE; // Inicializa com infinito
      anterior[v] = -1;
    }

    dist[origem] = 0;
    boolean[] visitado = new boolean[numVertices];

    for (int i = 0; i < numVertices; i++) {
      int u = -1;
      int menorDist = Integer.MAX_VALUE;
      for (int v = 0; v < numVertices; v++) {
        if (!visitado[v] && dist[v] < menorDist) {
          u = v;
          menorDist = dist[v];
        }
      }

      if (u == -1) break;

      visitado[u] = true;

      for (PVector aresta : arestas) {
        int v1 = (int) aresta.x;
        int v2 = (int) aresta.y;
        if (v1 == u || v2 == u) {
          int v = (v1 == u) ? v2 : v1;
          int peso = 1; // Supondo peso 1 para simplificação
          int alt = dist[u] + peso;
          if (alt < dist[v]) {
            dist[v] = alt;
            anterior[v] = u;
          }
        }
      }
    }

    ArrayList<Integer> caminhoMenor = new ArrayList<>();
    for (int i = destino; i != -1; i = anterior[i]) {
      caminhoMenor.add(i);
    }
    Collections.reverse(caminhoMenor); // Para obter o caminho na ordem correta

    return caminhoMenor;
  }
}
