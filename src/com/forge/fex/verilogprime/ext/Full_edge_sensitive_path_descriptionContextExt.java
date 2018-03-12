package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Full_edge_sensitive_path_descriptionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Full_edge_sensitive_path_descriptionContextExt extends AbstractBaseExt {

	public Full_edge_sensitive_path_descriptionContextExt(Full_edge_sensitive_path_descriptionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Full_edge_sensitive_path_descriptionContext getContext() {
		return (Full_edge_sensitive_path_descriptionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).full_edge_sensitive_path_description());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Full_edge_sensitive_path_descriptionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Full_edge_sensitive_path_descriptionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}