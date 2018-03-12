package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Genvar_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Genvar_identifierContextExt extends AbstractBaseExt {

	public Genvar_identifierContextExt(Genvar_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Genvar_identifierContext getContext() {
		return (Genvar_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).genvar_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Genvar_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Genvar_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected Boolean isPortDeclared(String portName) {
		if (portName.equals(getFormattedText())) {
			return true;
		} else {
			return false;
		}
	}
}