package com.neurq.common.crypto;

import org.bouncycastle.pqc.crypto.crystals.kyber.KyberKeyPairGenerator;
import org.bouncycastle.pqc.crypto.crystals.kyber.KyberParameters;
import org.bouncycastle.pqc.crypto.crystals.dilithium.DilithiumKeyPairGenerator;
import org.bouncycastle.pqc.crypto.crystals.dilithium.DilithiumParameters;
import org.bouncycastle.pqc.crypto.crystals.kyber.KyberPrivateKeyParameters;
import org.bouncycastle.pqc.crypto.crystals.kyber.KyberPublicKeyParameters;
import org.bouncycastle.pqc.crypto.crystals.dilithium.DilithiumPrivateKeyParameters;
import org.bouncycastle.pqc.crypto.crystals.dilithium.DilithiumPublicKeyParameters;
import org.bouncycastle.pqc.crypto.crystals.kyber.KyberKemGenerator;
import org.bouncycastle.pqc.crypto.crystals.kyber.KyberKemExtractor;
import org.bouncycastle.pqc.crypto.crystals.dilithium.DilithiumSigner;
import org.bouncycastle.crypto.AsymmetricCipherKeyPair;
import org.bouncycastle.crypto.KeyGenerationParameters;
import java.security.SecureRandom;
import java.nio.ByteBuffer;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * Quantum-Safe Cryptography Implementation
 * NIST PQC Standards: ML-KEM (FIPS 203), ML-DSA (FIPS 204)
 */
public class QuantumSafeCrypto {
    private static final SecureRandom RANDOM = new SecureRandom();
    
    public static class KeyPair {
        private final byte[] publicKey;
        private final byte[] privateKey;
        private final String algorithm;
        
        public KeyPair(byte[] publicKey, byte[] privateKey, String algorithm) {
            this.publicKey = publicKey;
            this.privateKey = privateKey;
            this.algorithm = algorithm;
        }
        
        public byte[] getPublicKey() { return publicKey; }
        public byte[] getPrivateKey() { return privateKey; }
        public String getAlgorithm() { return algorithm; }
    }
    
    /**
     * Generate Kyber key pair for encryption (ML-KEM)
     */
    public static KeyPair generateKyberKeyPair() {
        try {
            KyberKeyPairGenerator generator = new KyberKeyPairGenerator();
            KyberParameters params = KyberParameters.kyber768; // NIST Level 3
            generator.init(new org.bouncycastle.pqc.crypto.crystals.kyber.KyberKeyGenerationParameters(RANDOM, params));
            
            AsymmetricCipherKeyPair keyPair = generator.generateKeyPair();
            KyberPublicKeyParameters pubKey = (KyberPublicKeyParameters) keyPair.getPublic();
            KyberPrivateKeyParameters privKey = (KyberPrivateKeyParameters) keyPair.getPrivate();
            
            return new KeyPair(pubKey.getEncoded(), privKey.getEncoded(), "KYBER-768");
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate Kyber key pair", e);
        }
    }
    
    /**
     * Generate Dilithium key pair for digital signatures (ML-DSA)
     */
    public static KeyPair generateDilithiumKeyPair() {
        try {
            DilithiumKeyPairGenerator generator = new DilithiumKeyPairGenerator();
            DilithiumParameters params = DilithiumParameters.dilithium3; // NIST Level 3
            generator.init(new org.bouncycastle.pqc.crypto.crystals.dilithium.DilithiumKeyGenerationParameters(RANDOM, params));
            
            AsymmetricCipherKeyPair keyPair = generator.generateKeyPair();
            DilithiumPublicKeyParameters pubKey = (DilithiumPublicKeyParameters) keyPair.getPublic();
            DilithiumPrivateKeyParameters privKey = (DilithiumPrivateKeyParameters) keyPair.getPrivate();
            
            return new KeyPair(pubKey.getEncoded(), privKey.getEncoded(), "DILITHIUM-3");
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate Dilithium key pair", e);
        }
    }
    
    /**
     * Encrypt data using Kyber KEM
     */
    public static EncryptedData encrypt(byte[] data, byte[] recipientPublicKey) {
        try {
            KyberPublicKeyParameters pubKey = new KyberPublicKeyParameters(KyberParameters.kyber768, recipientPublicKey);
            KyberKemGenerator kemGen = new KyberKemGenerator(pubKey, RANDOM);
            
            org.bouncycastle.pqc.crypto.crystals.kyber.KyberKemGenerator.KyberKemCiphertext kemCiphertext = 
                kemGen.generateEncapsulation();
            
            // Use shared secret for symmetric encryption (AES-256-GCM)
            byte[] sharedSecret = kemCiphertext.getSharedSecret();
            byte[] encryptedData = AESGCM.encrypt(data, sharedSecret);
            
            return new EncryptedData(encryptedData, kemCiphertext.getEncapsulation(), "KYBER-768+AES-256-GCM");
        } catch (Exception e) {
            throw new RuntimeException("Failed to encrypt data", e);
        }
    }
    
    /**
     * Decrypt data using Kyber KEM
     */
    public static byte[] decrypt(EncryptedData encrypted, byte[] recipientPrivateKey) {
        try {
            KyberPrivateKeyParameters privKey = new KyberPrivateKeyParameters(KyberParameters.kyber768, recipientPrivateKey);
            KyberKemExtractor kemExt = new KyberKemExtractor(privKey);
            
            byte[] sharedSecret = kemExt.extractSecret(encrypted.getEncapsulation());
            return AESGCM.decrypt(encrypted.getData(), sharedSecret);
        } catch (Exception e) {
            throw new RuntimeException("Failed to decrypt data", e);
        }
    }
    
    /**
     * Sign data using Dilithium
     */
    public static byte[] sign(byte[] data, byte[] privateKey) {
        try {
            DilithiumSigner signer = new DilithiumSigner();
            DilithiumPrivateKeyParameters privKey = new DilithiumPrivateKeyParameters(DilithiumParameters.dilithium3, privateKey);
            signer.init(true, privKey);
            return signer.generateSignature(data);
        } catch (Exception e) {
            throw new RuntimeException("Failed to sign data", e);
        }
    }
    
    /**
     * Verify signature using Dilithium
     */
    public static boolean verify(byte[] data, byte[] signature, byte[] publicKey) {
        try {
            DilithiumSigner signer = new DilithiumSigner();
            DilithiumPublicKeyParameters pubKey = new DilithiumPublicKeyParameters(DilithiumParameters.dilithium3, publicKey);
            signer.init(false, pubKey);
            return signer.verifySignature(data, signature);
        } catch (Exception e) {
            return false;
        }
    }
    
    public static class EncryptedData {
        private final byte[] data;
        private final byte[] encapsulation;
        private final String algorithm;
        
        public EncryptedData(byte[] data, byte[] encapsulation, String algorithm) {
            this.data = data;
            this.encapsulation = encapsulation;
            this.algorithm = algorithm;
        }
        
        public byte[] getData() { return data; }
        public byte[] getEncapsulation() { return encapsulation; }
        public String getAlgorithm() { return algorithm; }
    }
    
    private static class AESGCM {
        public static byte[] encrypt(byte[] plaintext, byte[] key) throws Exception {
            // Derive AES key from shared secret (first 32 bytes)
            byte[] aesKey = new byte[32];
            System.arraycopy(key, 0, aesKey, 0, Math.min(key.length, 32));
            
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            byte[] iv = new byte[12];
            RANDOM.nextBytes(iv);
            GCMParameterSpec spec = new GCMParameterSpec(128, iv);
            SecretKeySpec keySpec = new SecretKeySpec(aesKey, "AES");
            cipher.init(Cipher.ENCRYPT_MODE, keySpec, spec);
            
            byte[] ciphertext = cipher.doFinal(plaintext);
            // Prepend IV to ciphertext
            ByteBuffer buffer = ByteBuffer.allocate(12 + ciphertext.length);
            buffer.put(iv);
            buffer.put(ciphertext);
            return buffer.array();
        }
        
        public static byte[] decrypt(byte[] ciphertext, byte[] key) throws Exception {
            // Extract IV from first 12 bytes
            byte[] iv = new byte[12];
            System.arraycopy(ciphertext, 0, iv, 0, 12);
            byte[] encrypted = new byte[ciphertext.length - 12];
            System.arraycopy(ciphertext, 12, encrypted, 0, encrypted.length);
            
            // Derive AES key from shared secret
            byte[] aesKey = new byte[32];
            System.arraycopy(key, 0, aesKey, 0, Math.min(key.length, 32));
            
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            GCMParameterSpec spec = new GCMParameterSpec(128, iv);
            SecretKeySpec keySpec = new SecretKeySpec(aesKey, "AES");
            cipher.init(Cipher.DECRYPT_MODE, keySpec, spec);
            return cipher.doFinal(encrypted);
        }
    }
}
