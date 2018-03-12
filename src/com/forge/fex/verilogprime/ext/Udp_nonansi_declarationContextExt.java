package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Udp_nonansi_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Udp_nonansi_declarationContextExt extends AbstractBaseExt {

	public Udp_nonansi_declarationContextExt(Udp_nonansi_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Udp_nonansi_declarationContext getContext() {
		return (Udp_nonansi_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).udp_nonansi_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Udp_nonansi_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Udp_nonansi_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}