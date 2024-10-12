# Node.js tabanlı bir imaj kullan
FROM node:14

# Çalışma dizinini oluştur ve ayarla
WORKDIR /usr/src/app

# package.json ve package-lock.json dosyalarını kopyala
COPY package*.json ./

# Uygulama bağımlılıklarını yükle
RUN npm install

# Uygulama dosyalarını kopyala
COPY . .

# Uygulamayı başlat
CMD ["node", "app.js"]

# Uygulamanın dinleyeceği port
EXPOSE 3001
