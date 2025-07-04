# Usa uma imagem oficial do Python como imagem base.
# Alpine Linux é usado por seu tamanho reduzido. Python 3.11 é uma versão estável.
FROM python:3.11-alpine

# Define variáveis de ambiente para impedir que o Python grave arquivos .pyc no disco
# e para impedir o buffer de stdout e stderr.
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Define o diretório de trabalho no contêiner.
WORKDIR /app

# Copia o arquivo de dependências para o diretório de trabalho.
COPY requirements.txt .

# Instala os pacotes necessários especificados no requirements.txt.
# --no-cache-dir reduz o tamanho da imagem.
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante do código-fonte da aplicação do host para o contêiner.
COPY . .

# Cria um usuário e grupo não-root por motivos de segurança.
# Executar como um usuário não-root é uma boa prática de segurança.
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Muda para o usuário não-root.
USER appuser

# Expõe a porta 8000 para o mundo fora deste contêiner.
EXPOSE 8000

# Define o comando para executar a aplicação.
# Use 0.0.0.0 para vincular a todas as interfaces de rede, tornando a aplicação acessível de fora do contêiner.
# A flag --reload é para desenvolvimento e não deve ser usada em um Dockerfile de produção.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
